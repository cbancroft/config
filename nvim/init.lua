---------------------------------------------------------
-- Import Lua Stuff
---------------------------------------------------------
MAP = vim.api.nvim_set_keymap
MAP_DEFAULTS = { noremap = true, silent = true }
CMD = vim.cmd
NOP = '<nop>'
R = function(name)
  -- print('Loading ' .. name)
  -- package.loaded[name] = nil
  local status, pkg = pcall(require, name)
  if not status then
    print("Error loading lua module '" .. name .. "': " .. tostring(pkg))
    return nil
  end
  return pkg
end

function mapn(...)
  MAP('n', ...)
end

function mapnl(binding, ...)
  MAP('n', '<leader>' .. binding, ...)
end

PLUGINS = {
  coq = {
    enabled = false,
  },
  nvim_cmp = {
    enabled = true,
  },
  fzf_lua = {
    enabled = false,
  },
  telescope = {
    enabled = true,
  }
}

local init_path = debug.getinfo(1, 'S').source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

require 'cb.bootstrap':init(base_dir)

require 'cb.config':load()

local plugins = require 'cb.plugins'
require 'cb.plugin-loader'.load {plugins, cb.plugins}

local commands = require 'cb.core.commands'
commands.load(commands.defaults)

require 'cb.lsp'.setup()

-- Load all the things
-- R('cbancroft.plugins')
-- R 'cbancroft.cmp'
-- R 'cbancroft.lsp'
-- R 'cbancroft.telescope'
-- R 'cbancroft.plugins.treesitter'
