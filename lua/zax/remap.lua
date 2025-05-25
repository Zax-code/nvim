vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

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

vim.keymap.set({ "n", "x", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "x", "v" }, "<leader>c", "\"+p")
vim.keymap.set({ "n", "x", "v" }, "<leader>C", "\"+P")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


vim.keymap.set({ "n", "x", "v" }, "<leader>w", ":w<Enter>")
vim.keymap.set({ "n", "x", "v" }, "<leader>s", ":wa<Enter>")
vim.keymap.set({ "n", "x", "v" }, "<leader>q", ":wq<Enter>")

vim.keymap.set("n", "<leader>n", "o<Esc>\"+p")
-- Open new file in new tab with <leader>t (specify the file name)
vim.keymap.set("n", "<leader>t", ":tabnew <C-r>=expand('%:p:h') . '/'<CR><Enter>", { noremap = true, silent = true })
