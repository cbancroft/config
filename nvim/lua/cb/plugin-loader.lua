local plugin_loader = {}

local utils = require'cb.utils'
local join_paths = utils.join_paths
local in_headless = #vim.api.nvim_list_uis() == 0

local compile_path = join_paths(get_config_dir(), 'plugin', 'packer_compiled.lua')
local snapshot_path = join_paths(get_cache_dir(), 'snapshots')
local default_snapshot = join_paths(get_base_dir(), 'snapshots', 'default.json')

function plugin_loader.init(opts)
  opts = opts or {}

  local install_path = opts.install_path or join_paths(vim.fn.stdpath 'data', 'site', 'pack', 'packer', 'start', 'packer.nvim')

  local init_opts = {
    package_root = opts.package_root or join_paths(vim.fn.stdpath 'data', 'site', 'pack'),
    compile_path = compile_path,
    snapshot_path = snapshot_path,
    log = { level = 'warn' },
    git = {
      clone_timeout = 300
    },
    display = {
      open_fn = function()
        return require('packer.util').float {border = 'rounded'}
      end,
    },
  }

  if in_headless then
    print('Clearing display in headless mode')
    init_opts.display = nil
  end

  if not utils.is_directory(install_path) then
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
    vim.cmd 'packadd packer.nvim'
    init_opts.snapshot = default_snapshot
  end

  local status_ok, packer = pcall(require, 'packer')
  if status_ok then
    packer.on_complete = vim.schedule_wrap(function()
      require('cb.utils.hooks').run_on_packer_complete()
    end)
    packer.init(init_opts)
  end
end

local function pcall_packer_command(cmd, kwargs)
  local status_ok, msg = pcall(function()
    require('packer')[cmd](table.unpack(kwargs or {}))
  end)
end

function plugin_loader.cache_clear()
  if vim.fn.delete(compile_path) == 0 then
    print 'Deleted packer_compiled.lua'
  end
end

function plugin_loader.recompile()
  plugin_loader.cache_clear()
  pcall_packer_command 'compile'
  if utils.is_file(compile_path) then

  end
end

function plugin_loader.reload(configurations)
  _G.packer_plugins = _G.packer_plugins or {}
  for k,v in pairs(_G.packer_plugins) do
    if k ~= 'packer.nvim' then
      _G.packer_plugins[v] = nil
    end
  end
  plugin_loader.load(configurations)
  plugin_loader.ensure_plugins()
end

function plugin_loader.load(configurations)
  local packer_available, packer = pcall(require, 'packer')
  if not packer_available then
    print 'skipping loading plugins until Packer is installed'
    return
  end

  local status_ok, _ = xpcall(function()
    packer.reset()
    packer.startup(function(use)
      for _, plugins in ipairs(configurations) do
        for _, plugin in ipairs(plugins) do
          use(plugin)
        end
      end
    end)
    vim.g.colors_name = cb.colorscheme
    vim.cmd('colorscheme ' .. cb.colorscheme)
  end, debug.traceback)
  if not status_ok then

  end
end

function plugin_loader.get_core_plugins()
  local list = {}
  local plugins = require 'cb.plugins'
  for _, item in pairs(plugins) do
    if not item.disable then
      table.insert(list, item[1]:match "/(%S*)")
    end
  end
  return list
end

function plugin_loader.load_snapshot(snapshot_file)
  snapshot_file = snapshot_file or default_snapshot
  if not in_headless then
    vim.notify('Syncing core plugins is in progres..', vim.log.levels.INFO)
  end

  local core_plugins = plugin_loader.get_core_plugins()
  require('packer').rollback(snapshot_file, table.unpack(core_plugins))
end

function plugin_loader.sync_core_plugins()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    once = true,
    callback = function()
      require('cb.plugin-loader').load_snapshot(default_snapshot)
    end,
  })
  pcall_packer_command 'sync'
end

function plugin_loader.ensure_plugins()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    once = true,
    callback = function()
      pcall_packer_command 'clean'
    end,
  })
  pcall_packer_command 'install'
end

return plugin_loader
