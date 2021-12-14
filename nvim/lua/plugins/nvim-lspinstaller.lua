local lsp_installer = require("nvim-lsp-installer")

-- Provide settings first!
lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },

  -- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
  -- servers that are requested to be installed will be put in a queue.
  max_concurrent_installers = 4,
})

---------------------------------------------------
local function make_server_ready(attach)
  lsp_installer.on_server_ready(function(server)
    local opts = {}
    opts.on_attach = attach

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
  end)
end
---------------------------------------------------

---------------------------------------------------
local function install_server(server)
  local lsp_installer_servers = require("nvim-lsp-installer.servers")
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
local servers = { "bashls", "pyright", "clangd", "html", "tsserver", "jsonls", "sumneko_lua" }

-- setup the LS
require("plugins.nvim-lspconfig")
make_server_ready(my_on_attach) -- LSP mappings

-- install the LS
for _, server in ipairs(servers) do
  install_server(server)
end
