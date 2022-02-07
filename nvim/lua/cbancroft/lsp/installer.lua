local lsp_installer = R 'nvim-lsp-installer'
if not lsp_installer then
  return
end

-- Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = R('cbancroft.lsp.handlers').on_attach,
    capabilities = R('cbancroft.lsp.handlers').capabilities,
  }

  if server.name == 'sumneko_lua' then
    local sumneko_opts = R 'cbancroft.lsp.settings.sumneko'
    opts = vim.tbl_deep_extend('force', sumneko_opts, opts)
  end

  -- This setup() function is exactly the same as lspconfig's setup function
  server:setup(opts)
end)
