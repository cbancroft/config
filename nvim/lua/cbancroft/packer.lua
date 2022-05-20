----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- https://github.com/wbthomason/packer.nvim

-- For information about installed plugins see the README
--- neovim-lua/README.md
--- https://github.com/brainfucksec/neovim-lua#readme

local M = {}

-- Automatically install packer
local packer_bootstrap = false

local u = require('cbancroft.utils')
local present, packer = pcall(require, 'packer')

if not present then
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  u.info('Cloning packer...', 'Packer')

  -- Remove the directory before cloning
  vim.fn.delete(install_path, 'rf')
  vim.fn.system {
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    '--depth',
    '20',
    install_path,
  }

  vim.cmd 'packadd packer.nvim'
  present, packer = pcall(require, 'packer')

  if present then
    u.info('Packer cloned successfully', 'Packer')
    packer_bootstrap = true
  else
    error("Couldn't clone packer.\nPacker path: " .. install_path .. '\n' .. packer)
  end
end

-- Setup packer
packer.init {
  display = {
    open_fn = function()
      return require 'packer.util'.float { border = 'rounded' }
    end,
    prompt_border = 'rounded',
  },
  git = {
    clone_timeout = 800, -- Timeout, in seconds, for git clone
  },
  auto_clean = true,
  compile_on_sync = true,
}

return {
  packer = packer,
  first_install = packer_bootstrap
}
