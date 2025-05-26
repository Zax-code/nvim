-- Copilot configuration for Neovim
vim.g.copilot_no_tab_map = true
vim.keymap.set('n', '<leader>cp', ':Copilot panel<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-q>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-m>', 'copilot#Next()', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-o>', 'copilot#Previous()', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<C-e>', 'copilot#Dismiss()', {
  expr = true,
  replace_keycodes = false
})
