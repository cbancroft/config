local utils = require 'cb.utils'

local M = {}
local config_dir = vim.call('stdpath', 'config')
local config_file = utils.join_paths(config_dir, 'config.lua')

local function apply_defaults(configs, defaults)
  configs = configs or {}
  return vim.tbl_deep_extend('keep', configs, defaults)
end

-- Get the full path to the config overrides file
-- @return string
function M.get_config_file()
  return config_file
end

-- Initialize default config and define the cb global config variable
function M:init()
  if vim.tbl_isempty(cb or {}) then
    cb = vim.deepcopy(require 'cb.config.defaults')
    local home_dir = vim.loop.os_homedir()
    cb.vsnip_dir = utils.join_paths(home_dir, '.config', 'snippets')
    cb.database = { save_location = utils.join_paths(home_dir, '.config', 'cbnvim_db'), auto_execute = 1 }
  end

  require 'cb.keymappings'.load_defaults()

  local builtins = require 'cb.core.builtins'
  builtins.config { config_file = config_file }

  local settings = require 'cb.config.settings'
  settings.load_options()

  local autocmds = require 'cb.core.autocmds'
  cb.autocommands = apply_defaults(cb.autocommands, autocmds.load_augroups())

  local lsp_config = require 'cb.lsp.config'
  cb.lsp = apply_defaults(cb.lsp, vim.deepcopy(lsp_config))
  require 'cb.lsp.manager'.init_defaults()
end

-- Override the base config without having to deep update all my configs
-- @param config_path Override path
function M:load(config_path)
  local autocmds = require 'cb.core.autocmds'
  config_path = config_path or self.get_config_file()
  local ok, err = pcall(dofile, config_path)
  if not ok then
    if utils.is_file(config_file) then
      print('Invalid configuration override file: ' .. err)
    else
      print(string.format('Unable to find configuration file [%s]', config_path))
    end
  end

  autocmds.define_augroups(cb.autocommands)
  vim.g.mapleader = (cb.leader == 'space' and ' ') or cb.leader

  require 'cb.keymappings'.load(cb.keys)
end

-- Reload the configuration
function M:reload()
  vim.schedule(function()
    require_clean('cb.utils.hooks').run_pre_reload()

    M:init()
    M:load()

    require 'cb.core.autocmds'.configure_format_on_save()

    local plugins = require 'cb.plugins'
    local plugin_loader = require 'cb.plugin-loader'

    plugin_loader.reload { plugins, cb.plugins }
    require_clean('cb.utils.hooks').run_post_reload()
  end)
end

return M
