local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"
local in_headless = #vim.api.nvim_list_uis() == 0

-- Join path segments that were passed as input
-- @return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

function _G.get_cache_dir()
  return vim.call('stdpath', 'cache')
end

function _G.get_config_dir()
  return vim.call('stdpath', 'config')
end

function _G.get_runtime_dir()
  return vim.call('stdpath', 'data')
end
-- Require a module in protected mode, clearing it from cache first
-- @param module string
-- @return any
function _G.require_clean(module)
  package.loaded[module] = nil
  _G[module] = nil
  local _, requested = pcall(require, module)
  return requested
end

-- Initialize the `&runtimepath` variables and prepare for startup
-- @return table
function M:init(base_dir)
  self.runtime_dir = vim.call('stdpath', 'data')
  self.config_dir = vim.call('stdpath', 'config')
  self.cache_dir = vim.call('stdpath', 'cache')
  self.pack_dir = join_paths(self.runtime_dir, 'site', 'pack')
  self.packer_install_dir = join_paths(self.runtime_dir, 'site', 'pack', 'packer', 'start', 'packer.nvim')
  self.packer_cache_path = join_paths(self.config_dir, 'plugin', 'packer_compiled.lua')

  function _G.get_base_dir()
    return base_dir
  end

  require 'cb.config':init()

  require 'cb.plugin-loader'.init {
    package_root = self.pack_dir,
    install_path = self.packer_install_dir,
  }
end

return M
