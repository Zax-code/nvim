vim.keymap.set("n", "gc", function()
	local message = vim.fn.input("Commit message: ")
	vim.cmd.Git("commit -m '" .. message .. "'")
end)

vim.keymap.set("n", "gpl", function()
	vim.cmd.Git("pull")
end)

vim.keymap.set("n", "gps", function()
	vim.cmd.Git("push")
end)

vim.keymap.set("n", "gl", function()
	vim.cmd.Git("log")
end)

vim.keymap.set("n", "gL", function()
	vim.cmd.Git("log --graph --oneline --decorate")
end)

vim.keymap.set("n", "gs", function()
	vim.cmd.Git("status")
end)

vim.keymap.set("n", "gk", function()
	vim.api.nvim_feedkeys(":Git checkout ", "n", false)
end)

vim.keymap.set("n", "gA", function()
	vim.cmd.Git("add .")
end)

vim.keymap.set("n", "ga", function()
	vim.cmd.Git("add %")
end)

vim.keymap.set("n", "<leader>gg", function()
	vim.cmd.Git()
end)
