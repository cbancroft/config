local M = {}

local nls_utils = R 'cbancroft.lsp.null_ls.utils'
local nls_sources = R 'null-ls.sources'

local method = R 'null-ls'.methods.DIAGNOSTICS

function M.list_registered(filetype)
  local registered_providers = nls_utils.list_registered_providers_names(filetype)
  return registered_providers[method] or {}
end

function M.list_supported(filetype)
  local supported_linters = nls_sources.get_supported(filetype, 'diagnostics')
  table.sort(supported_linters)
  return supported_linters
end

return M
