local M = {}

-- Load the default set of autogroups and autocommands
function M.load_augroups()
  local config_file = require('cb.config'):get_config_file()

  if vim.loop.os_uname().version:match "Windows" then
    config_file = config_file:gsub("\\", "/")
  end

  return {
    _general_settings = {
      -- Close certain filetypes with just a 'q'
      { 'FileType', 'qf,help,man', 'nnoremap <silent> <buffer> q :close<cr>'},
      {
        'TextYankPost',
        '*',
        'lua require("vim.highlight").on_yank({higroup = "Search", timeout=200})'
      },
      {
        'BufWinEnter',
        'dashboard',
        'setlocal cursorline signcolumn=yes cursorcolumn number'
      },
      { 'BufWritePost', config_file, 'lua require("cb.config"):reload()'},
      { 'FileType', 'qf', 'set nobuflisted'},
    },
    _formatoptions = {
      {
        'BufWinEnter,BufRead,BufNewFile',
        '*',
        'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'
      }
    },
    _filetypechanges = {},
    _git = {
      { 'FileType', 'gitcommit', 'setlocal wrap'},
      { 'FileType', 'gitcommit', 'setlocal spell'},
    },
    _markdown = {
      {'FileType', 'markdown', 'setlocal wrap'},
      {'FileType', 'markdown', 'setlocal spell'}
    },
    _buffer_bindings = {
      {'FileType', 'floaterm', 'nnoremap <silent> <buffer> q :q<CR>'}
    },
    _auto_resize = {
      -- Cause split windows to be resized if main is resized
      {'VimResized', '*', 'tabdo wincmd ='},
    },
    _general_lsp = {
      { 'FileType', 'lspinfo,lsp-installer,null-ls-info', 'nnoremap <silent> <buffer> q :close<cr>'}
    },
    _custom_groups = {}
  }
end

local get_format_on_save_opts = function()
  local defaults = require('cb.config.defaults').format_on_save
  if type(cb.format_on_save) ~= 'table' then
    return defaults
  end

  return {
    pattern = cb.format_on_save.pattern or defaults.pattern,
    timeout = cb.format_on_save.timeout or defaults.timeout
  }
end

function M.enable_format_on_save()
  local opts = get_format_on_save_opts()
  vim.api.nvim_create_augroup('lsp_format_on_save', {})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'lsp_format_on_save',
    pattern = opts.pattern,
    callback = function()
      require('cb.lsp.utils').format { timeout_ms = opts.timeout, filter = opts.filter }
    end,
  })
  print('Enabled format-on-save')
end

function M.disable_format_on_save()
  pcall(vim.api.nvim_del_augroup_by_name, 'lsp_format_on_save')
  print('Disabled format-on-save')
end
function M.configure_format_on_save()
  if cb.format_on_save then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

function M.toggle_format_on_save()
  local status, _ = pcall(vim.api.nvim_get_autocmds, {
    group = 'lsp_format_on_save',
    event = 'BufWritePre'
  })
  if not status then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

-- Disable autocommand groups if they exist
-- @param name the augroup name
function M.disable_augroup(name)
  -- defer in case the augroup is still in use
  vim.schedule(function()
    if vim.fn.exists('#' .. name) == 1 then
      vim.cmd('augroup ' .. name)
      vim.cmd 'autocmd!'
      vim.cmd 'augroup END'
    end
  end)
end


-- Create auto command groups based on the passed definitions
-- @param definitions table containing trigger, pattern and text.
function M.define_augroups(definitions, buffer)
  for group_name, definition in pairs(definitions) do
    vim.cmd('augroup ' .. group_name)
    if buffer then
      vim.cmd [[autocmd! * buffer]]
    else
      vim.cmd [[autocmd!]]
    end

    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
      vim.cmd(command)
    end

    vim.cmd 'augroup END'
  end
end

return M
