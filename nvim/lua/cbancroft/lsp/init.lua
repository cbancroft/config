-- local lspsignature = require 'lsp_signature'
-- lspsignature.setup {
--   bind = true,
--   handler_opts = {
--     border = "rounded",
--   }
-- }

local M = {}
local servers = {
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require 'schemastore'.json.schemas(),
      }
    }
  },
  pyright = {},
  clangd = {},
  rust_analyzer = {},
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the LS which version of Lua we're using
          version = 'LuaJIT',
          -- Setup lua path
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          -- Get language server to recognize the `vim` global
          globals = { 'vim' }
        },
        workspace = {
          -- Make the server aware of neovim runtime files
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          }
        },
        telemetry = { enable = false },
      }
    }
  },
  tsserver = {},
  vimls = {},
}

local function on_attach(client, bufnr)
  -- Enable completion triggered by <C-x><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more info
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use LSP as the handler for formatexpr
  -- See `:help formatexpr` for more info
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  -- Configure key mappings
  require('cbancroft.lsp.keymaps').setup(client, bufnr)

  -- Configure highlighting
  require('cbancroft.lsp.highlighting').setup(client)

  -- Configure formatting
  require 'cbancroft.lsp.null_ls.formatters'.setup(client, bufnr)

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
if PLUGINS.nvim_cmp.enabled then
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
end

local opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

local function install_additional_lsps()
  local configs = require 'lspconfig.configs'
  if not configs.rst then
    configs.rst = {
      default_config = {
        cmd = { 'rst-lsp-serve', '--log-file', vim.fn.expand '~/.cache/nvim/rst-lsp.log' },
        filetypes = { 'rst' },
        root_dir = function(fname)
          return nvim_lsp.util.root_pattern('conf.py', '.git')(fname)
        end,
        flags = {
          allow_incremental_sync = true,
        },
        on_init = function(client)
          if not client.config.flags then
            client.config.flags = {}
          end
          if not client.config.settings then
            client.config.settings = {}
          end
          if not client.config.settings.rst_lsp then
            client.config.settings.rst_lsp = {}
          end
          client.config.flags.allow_incremental_sync = true

          client.config.settings.rst_lsp.conf_path = client.config.root_dir .. '/conf.py'
        end,
        settings = {},
      },
    }
  end
end

-- Setup handler methods used when entering/exiting an LSP supported buffer
require('cbancroft.lsp.handlers').setup()

function M.setup()
  install_additional_lsps()

  -- null-ls
  R 'cbancroft.lsp.null_ls'.setup(opts)

  -- LSP Installer
  R 'cbancroft.lsp.installer'.setup(servers, opts)
end

return M
