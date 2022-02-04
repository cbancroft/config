-- Jump to the first available definition every time
vim.lsp.handlers['textDocument/definition'] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print '[LSP] Could not find definition'
    return
  end

  if vim.tbl_islist(result) then
    vim.lsp.util.jump_to_location(result[1])
  else
    vim.lsp.util.jump_to_location(result)
  end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  signs = true,
  update_in_insert = true,
  virtual_text = {
    true,
    spacing = 6,
    -- severity_limit = 'Error'   -- Only show virtual text on error
  },
})

local M = {}

M.implementation = function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, 'textDocument/implementation', params, function(err, result, ctx, config)
    local bufnr = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    vim.lsp.handlers['textDocument/implementation'](err, result, ctx, config)
    vim.cmd [[normal! zz]]
  end)
end

return M
