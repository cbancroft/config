local M = {}

local cb_lsp_utils = require 'cb.lsp.utils'

function M.init_defaults(languages)
  languages = languages or cb_lsp_utils.get_all_supported_filetypes()

  for _, entry in ipairs(languages) do
    if not cb.lang[entry] then
      cb.lang[entry] = {
        formatters = {},
        linters = {},
        lsp = {}
      }
    end
  end
end

-- Resolde the config for a server by merging it with the default config
local function resolve_config(server_name, ...)
  local defaults = {
    on_attach = require('cb.lsp').common_on_attach,
    on_init = require('cb.lsp').common_on_init,
    on_exit = require('cb.lsp').common_on_exit,
    capabilities = require('cb.lsp').common_capabilities(),
  }

  local has_custom_provider, custom_config = pcall(require, 'cb/lsp/providers/' .. server_name)
  if has_custom_provider then
    defaults = vim.tbl_deep_extend('force', defaults, custom_config)
  end

  defaults = vim.tbl_deep_extend('force', defaults, ...)

  return defaults
end

-- Manually start the server and don't wait for the usual filetype trigger from lspconfig
local function buf_try_add(server_name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  require'lspconfig'[server_name].manager.try_add_wrapper(bufnr)
end

-- Check if the manager autocmd has been configured since some servers take a bit
-- to initialize.
local function client_is_configured(server_name, ft)
  ft = ft or vim.bo.filetype
  local active_autocmds = vim.split(vim.fn.execute('autocmd FileType ' .. ft), '\n')
  for _, result in ipairs(active_autocmds) do
    if result:match(server_name) then
      return true
    end
  end
  return false
end

local function launch_server(server_name, config)
  pcall(function()
    require'lspconfig'[server_name].setup(config)
    buf_try_add(server_name)
  end)
end

-- Setup a LSP by providing a name
function M.setup(server_name, user_config)
  vim.validate { name = { server_name, 'string'}}
  user_config = user_config or {}

  if cb_lsp_utils.is_client_active(server_name) or client_is_configured(server_name) then
    return
  end

  local servers = require 'nvim-lsp-installer.servers'
  local server_available, server = servers.get_server(server_name)

  if not server_available then
    local config = resolve_config(server_name, user_config)
    launch_server(server_name, config)
    return
  end

  local install_in_progress = false

  if not server:is_installed() then
    if cb.lsp.automatic_servers_installation then
      server:install()
      install_in_progress = true
    end
  end

  server:on_ready(function()
    if install_in_progress then
      vim.notify(string.format('Installation complete for [%s] server', server.name), vim.log.levels.INFO)
    end
    install_in_progress = false
    local config = resolve_config(server_name, server:get_default_options(), user_config)
    launch_server(server_name, config)
  end)
end

return M
