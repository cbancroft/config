local M = {}

local nls_utils = R 'cbancroft.lsp.null_ls.utils'
local method = R 'null-ls'.methods.HOVER

function M.list_registered(filetype)
  local registered_providers = nls_utils.list_registered_providers_names(filetype)
  return registered_providers[method] or {}
end

return M
