vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--cool feature to move written lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--easier to move around
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

print(vim.keymap.set("n", "<leader>y", "\"+y"))
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

function Keypress(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

function RenameBuffer(name)
  local buffer_number = vim.fn.bufnr(name)
  if buffer_number ~= -1 then
    vim.cmd("bdelete! " .. buffer_number)
  end
  vim.cmd("file " .. name)
end

function Open_dev_server(pathToFile)
  -- Check if the current directory contains a "package.json" file
  local cwd = vim.fn.getcwd()
  local package_json_path = cwd .. "/package.json"
  -- check if the file exists and it contains the run dev script
  if vim.fn.filereadable(package_json_path) == 1 then
    local package_json = vim.fn.json_decode(vim.fn.readfile(package_json_path))
    if not package_json.scripts["dev"] then
      return false
    end
  else
    return false
  end
  -- Open a new tab and switch to it
  vim.cmd("tabnew")
  -- Open a terminal window in the new tab
  vim.cmd("terminal")
  --delete buffer with name "dev-server" then rename current tab to "dev-server"
  RenameBuffer("dev-server")
  --start writing in the terminal and write "npm run dev"
  vim.api.nvim_feedkeys("icd " .. pathToFile .. " && npm run dev", "t", true)
  --press enter to execute the command
  Keypress("<CR>", "t")
  --press escape to exit the terminal
  Keypress("<Esc>", "t")
  return true
end

function ExecuteFile()
  local file = vim.fn.expand("%")
  local filename = vim.fn.fnamemodify(file, ":t:r")
  local extension = vim.fn.fnamemodify(file, ":e")
  --save file before executing
  vim.cmd("w")
  local pathToFile = vim.fn.fnamemodify(file, ":p:h")
  if (extension == "js" or extension == "vue" or extension == "jsx"
      or extension == "css") and Open_dev_server(pathToFile) then
    return
  end
  if extension == "sh" then
    if vim.fn.bufwinnr("sh " .. filename) == -1 then
      vim.cmd("vsplit")
    end
    vim.cmd("wincmd l")
    vim.cmd("vertical resize 100")
    vim.cmd("terminal")
    RenameBuffer("sh " .. filename)
    vim.api.nvim_feedkeys("icd " .. pathToFile .. " && ./" .. filename .. "." .. extension, "t", true)
    Keypress("<CR>", "t")
    Keypress("<Esc>", "t")
  end
  if extension == "js" then
    if vim.fn.bufwinnr("js " .. filename) == -1 then
      vim.cmd("vsplit")
    end
    vim.cmd("wincmd l")
    vim.cmd("vertical resize 100")
    vim.cmd("terminal")
    RenameBuffer("node " .. filename)
    vim.api.nvim_feedkeys("icd " .. pathToFile .. " && node " .. file, "t", true)
    Keypress("<CR>", "t")
    Keypress("<Esc>", "t")
  end
  if extension == "html" then
      -- Open a new tab and switch to it
      vim.cmd("tabnew")
      -- Open a terminal window in the new tab
      vim.cmd("terminal")
      --delete buffer with name "dev-server" then rename current tab to "dev-server"
      RenameBuffer("dev-server")
      --start writing in the terminal and write "npm run dev"
      vim.api.nvim_feedkeys("icd " .. pathToFile .. " && live-server", "t", true)
      --press enter to execute the command
      Keypress("<CR>", "t")
      --press escape to exit the terminal
      Keypress("<Esc>", "t")
  end
  if extension == "py" then
    if vim.fn.bufwinnr("py " .. filename) == -1 then
      vim.cmd("vsplit")
    end
    vim.cmd("wincmd l")
    vim.cmd("vertical resize 100")
    vim.cmd("terminal")
    RenameBuffer("python " .. filename)
    vim.api.nvim_feedkeys("icd " .. pathToFile .. " && python3 " .. file, "t", true)
    Keypress("<CR>", "t")
    Keypress("<Esc>", "t")
  end
  if extension == "c" then
    --ask for the arguments when executing the file
    local args = " " .. vim.fn.input("Arguments: ")
    if vim.fn.bufwinnr("gcc " .. filename) == -1 then
      vim.cmd("vsplit")
    end
    vim.cmd("wincmd l")
    vim.cmd("vertical resize 100")
    vim.cmd("terminal")
    RenameBuffer("gcc " .. filename)
    vim.api.nvim_feedkeys("icd " .. pathToFile .. " && gcc " .. file .. " -o " .. filename .. " && ./" ..
      filename .. args, "t", true)
    Keypress("<CR>", "t")
    Keypress("<Esc>", "t")
  end
  if extension == "cpp" then
    local args = " " .. vim.fn.input("Arguments: ")
    if vim.fn.bufwinnr("g++ " .. filename) == -1 then
      vim.cmd("vsplit")
    end
    vim.cmd("wincmd l")
    vim.cmd("vertical resize 100")
    vim.cmd("terminal")
    RenameBuffer("g++ " .. filename)
    vim.api.nvim_feedkeys("icd " .. pathToFile .. " && g++ " .. file .. " -o " .. filename .. " && ./" ..
      filename .. args, "t", true)
    Keypress("<CR>", "t")
    Keypress("<Esc>", "t")
  end
end

vim.keymap.set("n", "<F5>", ExecuteFile, { noremap = true })
