local lsp_installer = require 'nvim-lsp-installer'

-- Provide settings first!
lsp_installer.settings {
  ui = {
    icons = {
      server_installed = '✓',
      server_pending = '➜',
      server_uninstalled = '✗',
    },
  },

  -- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
  -- servers that are requested to be installed will be put in a queue.
  max_concurrent_installers = 4,
}

local function config(_config)
  -- caps = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.completion.completionItem.preselectSupport = true
  caps.textDocument.completion.completionItem.insertReplaceSupport = true
  caps.textDocument.completion.completionItem.labelDetailsSupport = true
  caps.textDocument.completion.completionItem.deprecatedSupport = true
  caps.textDocument.completion.completionItem.commitCharactersSupport = true
  caps.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  caps.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }
  return vim.tbl_deep_extend('force', {
    capabilities = caps,
  }, _config or {})
end
local lua_runtime_path = vim.split(package.path, ';')
table.insert(lua_runtime_path, 'lua/?.lua')
table.insert(lua_runtime_path, 'lua/?/init.lua')
local overrides = {
  pyright = {
    settings = {
      python = {
        pythonPath = 'python3',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
    single_file_support = true,
  },

  esbonio = {
    settings = {
      server = {
        logLevel = 'debug',
      },
    },
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = lua_runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}
---------------------------------------------------
local function make_server_ready(attach, capabilities)
  lsp_installer.on_server_ready(function(server)
    local opts = {}
    if overrides[server.name] ~= nil then
      opts = config(overrides[server.name])
    end
    opts.on_attach = attach
    opts.capabilities = capabilities

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end
---------------------------------------------------

---------------------------------------------------
local function install_server(server)
  local lsp_installer_servers = require 'nvim-lsp-installer.servers'
  local server_available, requested_server = lsp_installer_servers.get_server(server)
  if server_available then
    if not requested_server:is_installed() then
      requested_server:install(server)
    end
  end
end
---------------------------------------------------

---------------------------------------------------
--[[
Language servers:
Add your language server to `servers`
For language servers list see:
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
Bash --> bashls
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bashls
Python --> pyright
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
C-C++ -->  clangd
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
HTML/CSS/JSON --> vscode-html-languageserver
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
JavaScript/TypeScript --> tsserver
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
Lua --> sumneko_lua
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
--]]

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls', 'clangd', 'html', 'tsserver', 'jsonls', 'sumneko_lua', 'pylsp' }

-- setup the LS
local lsp_info = require 'plugins.nvim-lspconfig'

require 'plugins.nvim-lspconfig'
make_server_ready(lsp_info.on_attach, lsp_info.capabilities) -- LSP mappings

-- install the LS
for _, server in ipairs(servers) do
  install_server(server)
end
