local null_ls = require("null-ls")

-- I only use it for import sorting as formatting is handled by lsp-zero
null_ls.setup({
  sources = {
    -- Python
    null_ls.builtins.formatting.isort,
    -- Typescript import sorting

  },
})
