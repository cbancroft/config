local M = {}

function M.config()
  local dashboard = require 'cb.core.alpha.dashboard'
  local startify = require 'cb.core.alpha.startify'
  cb.builtin.alpha = {
    dashboard = { config = {}, section = dashboard.get_sections()},
    startify = { config = {}, section = startify.get_sections()},
    active = true,
    mode = 'dashboard'
  }
end

local function resolve_buttons(theme_name, entries)
  local selected_theme = require('alpha.themes.' .. theme_name)
  local val = {}
  for _, entry in pairs(entries) do
    local on_press = function()
      local sc_ = entry[1]:gsub('%s', ''):gsub(',', '<leader>')
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, 'normal', false)
    end
    local button_element = selected_theme.button(entry[1], entry[2], entry[3])
    button_element.on_press = on_press
    table.insert(val, button_element)
  end
  return val
end

local function resolve_config(theme_name)
  local selected_theme = require('alpha.themes.' .. theme_name)
  local resolved_section = selected_theme.section
  local section = cb.builtin.alpha[theme_name].section

  for name, el in pairs(section) do
    for k, v in pairs(el) do
      if name:match 'buttons' and k == 'entries' then
        resolved_section[name].val = resolve_buttons(theme_name, v)
      elseif v then
        resolved_section[name][k] = v
      end
    end
  end

  return selected_theme.config
end

local function configure_additional_autocmds()
  local aucmds = {
    {
      'FileType',
      'alpha',
      'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=' .. vim.opt.showtabline._value
    },
  }
  if not cb.builtin.lualine.options.globalstatus then
    aucmds[#aucmds + 1] =
    {
      'FileType',
      'alpha',
      'set laststatus=0 | autocmd BufUnload <buffer> set laststatus=' .. vim.opt.laststatus._value
    }
  end
  require('cb.core.autocmds').define_augroups{ _alpha = aucmds }
end

function M.setup()
  local alpha = require 'alpha'
  local mode = cb.builtin.alpha.mode
  local config = cb.builtin.alpha[mode].config

  if vim.tbl_isempty(config) then
    config = resolve_config(mode)
  end

  alpha.setup(config)
  configure_additional_autocmds()
end

return M

