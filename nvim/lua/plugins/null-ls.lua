local null_ls = require("null-ls")
local lSsources = {
  null_ls.builtins.formatting.prettier.with({
    filetypes = {
      "javascript",
      "typescript",
      "css",
      "scss",
      "html",
      "json",
      "yaml",
      "markdown",
      "graphql",
      "md",
      "txt",
    },
  }),
  null_ls.builtins.formatting.stylua.with({
    args = { "--indent-width", "2", "--indent-type", "Spaces", "-" },
  }),
}
require("null-ls").setup({
  sources = lSsources,
})
require("lspconfig")["null-ls"].setup({})
-- the duration in there is to stop timeouts on massive files
vim.cmd("autocmd BufWritePost *.lua lua vim.lsp.buf.formatting_seq_sync(nil, 7500)")
vim.o.updatetime = 250
