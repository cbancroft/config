local M = {}

function M.setup()
  local status_ok, null_ls = pcall(require, 'null-ls')
  if not status_ok then
    return
  end

  local default_opts = require('cb.lsp').get_common_opts()
  null_ls.setup(vim.tbl_deep_extend('force', default_opts, cb.lsp.null_ls.setup))
end

return M
