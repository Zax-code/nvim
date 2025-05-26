local M = {}

function M.input_floating(prompt_title, callback)
  local width = 50
  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = 1,
    row = math.floor(vim.o.lines / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = prompt_title,
    title_pos = "center",
  })

  -- Make buffer safe and invisible to quit logic
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = true

  vim.fn.prompt_setprompt(buf, "> ")
  vim.cmd("startinsert")

  vim.keymap.set("i", "<CR>", function()
    local input = vim.api.nvim_get_current_line():gsub("^> ", "")
    vim.api.nvim_win_close(win, true)
    callback(input)
  end, { buffer = buf })

  vim.keymap.set("i", "<C-c>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
end

function M.pick_directory(input_filename)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")
  local Job = require("plenary.job")

  -- 👇 You can customize ignored dirs here
  local ignored_dirs = {
    ".git",
    "node_modules",
    ".venv",
    "__pycache__",
    "dist",
  }

  -- Build find command with ignored dirs
  local find_cmd = { "find", ".", "-type", "d" }
  for _, dir in ipairs(ignored_dirs) do
    table.insert(find_cmd, "!")
    table.insert(find_cmd, "-path")
    table.insert(find_cmd, string.format("*/%s/*", dir))
  end

  -- Run it to get directory list
  local dirs = vim.fn.systemlist(find_cmd)

  pickers.new({}, {
    prompt_title = "Select Directory",
    finder = finders.new_table({ results = dirs }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      title = "Directory Contents",
      define_preview = function(self, entry, _)
        local dir = entry.value
        if not dir or dir == "" then return end

        Job:new({
          command = "ls",
          args = { "-A", "-l", "-1", "-F", "--sort=extension", dir }, -- -A excludes . and .., -1 forces one-per-line, -l for long listing, -F appends type indicators
          on_exit = function(j)
            local result = j:result()

            local cleaned = vim.tbl_filter(function(line)
              return line ~= "" and not line:match("^total")
            end, result)

            local buf_lines = {}
            table.insert(buf_lines, "") -- Top padding

            local hl_info = {}          -- to store lines + highlight groups

            for _, line in ipairs(cleaned) do
              local padded_line = line

              -- Determine type from line start (ls -l format)
              local mode = line:sub(1, 1)
              local hl_group = nil
              if mode == "d" then
                hl_group = "Directory"
              elseif mode == "l" then
                hl_group = "Operator"
              elseif mode == "-" and string.match(line, "^[a-z-]+x[a-z-]*") then
                hl_group = "Type"
              else
                hl_group = "Statement"
              end
              -- Split by space to get the filename
              -- Split by space to get the filename
              local parts = vim.split(padded_line, "%s+")
              if #parts >= 9 then
                padded_line = table.concat(parts, " ", 9) -- Join all parts after the 9th
              end

              padded_line = " - " .. padded_line .. "  " -- Add padding for better visibility
              table.insert(buf_lines, padded_line)

              if hl_group then
                table.insert(hl_info, { line = #buf_lines - 1, group = hl_group })
              end
            end

            table.insert(buf_lines, "") -- Bottom padding

            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(self.state.bufnr) then
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, buf_lines)

                -- Apply highlights
                for _, info in ipairs(hl_info) do
                  vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, info.group, info.line, 0, -1)
                end
              end
            end)
          end
        }):start()
      end,
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local dir = selection[1]
        local filepath = vim.fn.fnamemodify(dir .. "/" .. input_filename, ":p")
        vim.cmd("tabnew " .. filepath)
      end)
      return true
    end,
  }):find()
end

function M.create_file_in_dir()
  M.input_floating("New File Name", function(input)
    if not input or input == "" then
      vim.notify("Filename cannot be empty", vim.log.levels.WARN)
      return
    end
    M.pick_directory(input)
  end)
end

return M
