conform = require("conform")
conform.setup({
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 500,
	},
	formatters_by_ft = {
		vue = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		yaml = { "prettierd" },
		scss = { "prettierd" },
		xml = { "prettierd" },
		lua = { "stylua" },
		python = { "isort", "black" },
		markdown = { "prettierd" },
	},
	lsp_format = "fallback",
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	local start_time = vim.loop.hrtime()

	conform.format({
		async = false,
		notify_on_error = true,
		notify_no_formatters = true,
		callback = function()
			local end_time = vim.loop.hrtime()
			local duration = (end_time - start_time) / 1000000 -- Convert to ms
			print(string.format("Formatted in %.1fms", duration))
		end,
	})
end, { desc = "Format file", silent = true })
