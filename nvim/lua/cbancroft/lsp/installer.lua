local lsp_installer_servers = require 'nvim-lsp-installer.servers'
local utils = require 'cbancroft.utils'

local M = {}

local lsps_with_customization = {
  jsonls = true,
  pyright = true,
  sumneko_lua = true,
  clangd = true,
}

local setup_servers = function()
  local status_ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
  if not status_ok then
    utils.error(lsp_installer)
    return
  end

  -- Register a handler that will be called for all installed servers.
  lsp_installer.on_server_ready(function(server)
    local status_ok, handlers = pcall(require, 'cbancroft.lsp.handlers')
    if not status_ok then
      print('Could not load lsp handlers: ' .. tostring(handlers))
    end
    local opts = {
      on_attach = handlers.on_attach,
      capabilities = handlers.get_capabilities(),
      on_init = handlers.on_init,
      on_exit = handlers.on_exit,
    }
    if lsps_with_customization[server.name] then
      print('Setting up LSP Server ' .. server.name)
      local server_opts = R('cbancroft.lsp.settings.' .. server.name).setup(server)
      opts = vim.tbl_deep_extend('force', opts, server_opts)
    end

    -- This setup() function is exactly the same as lspconfig's setup function
    server:setup(opts)
  end)
end

function M.setup(servers, options)
  for server_name, _ in pairs(servers) do
    local server_available, server = lsp_installer_servers.get_server(server_name)

    if server_available then
      server:on_ready(function()
        local opts = vim.tbl_deep_extend("force", options, servers[server.name] or {})

        if server.name == 'sumneko_lua' then
          opts = R 'lua-dev'.setup { lspconfig = opts }
        end

        if PLUGINS.coq.enabled then
          local coq = require 'coq'
          server:setup(coq.lsp_ensure_capabilities(opts))
        end

        -- https://github.com/williamboman/nvim-lsp-installer/wiki/Rust
        if server.name == 'rust_analyzer' then
          require 'rust-tools'.setup {
            server = vim.tbl_deep_extend("force", server:get_default_options(), opts)
          }
          server:attach_buffers()
        else
          server:setup(opts)
        end
        utils.info(server.name, ' is ready.')
      end)

      if not server:is_installed() then
        utils.info("Installing " .. server.name)
        server:install()
      end
    else
      utils.error(server)
    end
  end
end

return M
