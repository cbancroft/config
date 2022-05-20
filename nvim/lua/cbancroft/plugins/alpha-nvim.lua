-----------------------------------------------------------
-- Dashboard configuration file
-----------------------------------------------------------

-- Plugin: alpha-nvim
-- https://github.com/goolord/alpha-nvim
local M = {}


function M.setup()
  local alpha = require 'alpha'
  local dashboard = require 'alpha.themes.dashboard'

  -- setup footer
  local function footer()
    local total_plugins = #vim.tbl_keys(packer_plugins)
    local datetime = os.date '%Y/%m/%d %H:%M:%S'
    local plugins_text = "\t" .. total_plugins .. " plugins  " .. datetime

    local fortune = require "alpha.fortune"
    local quote = table.concat(fortune(), "\n")

    return plugins_text .. "\n" .. quote
  end

  -- header
  dashboard.section.header.val = {
    '                                                    ',
    ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
    ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
    ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
    ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
    ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
    ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
    '                                                    ',
  }

  -- menu
  dashboard.section.buttons.val = {
    dashboard.button('e', ' New file', ':ene <BAR> startinsert<CR>'),
    dashboard.button('f', ' Find file', ':NvimTreeOpen<CR>'),
    dashboard.button('s', ' Settings', ':e $MYVIMRC<CR>'),
    dashboard.button('u', ' Update plugins', ':PackerUpdate<CR>'),
    dashboard.button('q', ' Quit', ':qa<CR>'),
  }

  dashboard.section.footer.val = footer()
  dashboard.section.footer.opts.hl = "Constant"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Function"
  dashboard.section.buttons.opts.hl_shortcut = "Type"
  dashboard.opts.opts.noautocmd = true

  alpha.setup(dashboard.opts)
end

return M
