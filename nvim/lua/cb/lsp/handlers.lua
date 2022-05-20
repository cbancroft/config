local M = {}

function M.setup()
  local config = {
    virtual_text = cb.lsp.diagnostics.virtual_text,
    signs = cb.lsp.diagnostics.signs,
    underline = cb.lsp.diagnostics.underline,
    update_in_insert = cb.lsp.diagnostics.update_in_insert,
    severity_sort = cb.lsp.diagnostics.severity_sort,
    float = cb.lsp.diagnostics.float,
  }
  vim.diagnostic.config(config)
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, cb.lsp.float)
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, cb.lsp.float)
end

return M
