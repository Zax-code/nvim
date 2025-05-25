local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", "dist", "build", "%.lock", "%.cache", "__pycache__", "%.pyc", "%.pyo" },
    mappings = {
      n = {
        ["<leader>t"] = actions.select_tab,
      },
      i = {
        ["<leader>t"] = actions.select_tab,
      }
    },
  },
})

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>gf', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
