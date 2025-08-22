local null_ls = require("null-ls")

require("mason-null-ls").setup({
	ensure_installed = nil, -- or a list like { "prettierd", "stylua" }
	automatic_installation = true, -- auto-install formatters/linters
	automatic_setup = true, -- auto-register with null-ls
})

-- If you want to add custom sources manually, you still can:
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,
	},
})
