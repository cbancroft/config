-- Serenity awesome theme
local util = require('awful.util')
local naughty = require('naughty')
local theme = {}

local function res(res_name)
   return theme.theme_dir .. "/" .. res_name
end

theme.name = "Devotion 2.0"
theme.theme_dir = util.getdir("config") .. "/themes/devotion"

theme.wallpapers = { res("wallpapers/plague.jpg"),
                     res("wallpapers/reaper.jpg") }
theme.icon_dir      = res("icons")

theme.font          = "Hack " .. vista.scale(6)
theme.mono_font     = "Hack " .. vista.scale(6)

-- Menu settings
theme.menu_submenu_icon = res("icons/submenu.png")
theme.menu_height       = vista.scale(15)
theme.menu_width        = vista.scale(110)
theme.menu_border_width = 0

theme.bg_systray = "#222222"

theme.border_width    = 1
theme.border_normal   = "#222222"
theme.border_focus    = "#000000"
theme.border_marked   = "#91231c"

theme.bg_normal       = "#00000099"
theme.bg_focus        = "#00000033"

-- theme.motive          = "#82ee76" -- spring
-- theme.motive          = "#e67b50" -- summer
-- theme.motive          = "#dbaf5d" -- autumn
theme.motive          = "#76eec6" -- winter

theme.bg_normal_color = "#00000099"
theme.bg_focus_color  = "#444444"
theme.bg_urgent       = "#7f7f7f"
theme.bg_minimize     = "#444444"
theme.bg_onscreen     = theme.bg_normal

theme.fg_normal       = "#ffffff"
theme.fg_focus        = "#ffffff"
theme.fg_urgent       = "#ffffff"
theme.fg_minimize     = "#ffffff"
theme.fg_onscreen     = "#7f7f7f"

-- {{{ Titlebar
theme.titlebar_close_button_focus  = res("icons/awoken/24x24/actions/dust-tab-close-active.png")
theme.titlebar_close_button_normal = res("icons/awoken/24x24/actions/dust-tab-close-inactive.png")

theme.titlebar_minimize_button_normal = res("icons/awoken/24x24/actions/stock_leave-fullscreen.png")
theme.titlebar_minimize_button_focus  = res("icons/awoken/24x24/actions/stock_leave-fullscreen.png")

theme.titlebar_ontop_button_focus_active  = res("icons/awoken/24x24/actions/top.png")
theme.titlebar_ontop_button_normal_active = res("icons/awoken/24x24/actions/top.png")
theme.titlebar_ontop_button_focus_inactive  = res("icons/awoken/24x24/actions/top.png")
theme.titlebar_ontop_button_normal_inactive = res("icons/awoken/24x24/actions/top.png")

theme.titlebar_sticky_button_focus_active  = res("icons/awoken/24x24/actions/sticky-notes.png")
theme.titlebar_sticky_button_normal_active = res("icons/awoken/24x24/actions/sticky-notes.png")
theme.titlebar_sticky_button_focus_inactive  = res("icons/awoken/24x24/actions/sticky-notes.png")
theme.titlebar_sticky_button_normal_inactive = res("icons/awoken/24x24/actions/sticky-notes.png")

theme.titlebar_floating_button_focus_active  = res("icons/awoken/24x24/actions/stock_navigator.png")
theme.titlebar_floating_button_normal_active = res("icons/awoken/24x24/actions/stock_navigator.png")
theme.titlebar_floating_button_focus_inactive  = res("icons/awoken/24x24/actions/stock_navigator.png")
theme.titlebar_floating_button_normal_inactive = res("icons/awoken/24x24/actions/stock_navigator.png")

theme.titlebar_maximized_button_focus_active  = res("icons/awoken/24x24/actions/stock_leave-fullscreen.png")
theme.titlebar_maximized_button_normal_active = res("icons/awoken/24x24/actions/stock_leave-fullscreen.png")
theme.titlebar_maximized_button_focus_inactive  = res("icons/awoken/24x24/actions/stock_leave-fullscreen.png")
theme.titlebar_maximized_button_normal_inactive = res("icons/awoken/24x24/actions/stock_leave-fullscreen.png")
-- }}}

-- Configure naughty
if naughty then
   local presets = naughty.config.presets
   presets.normal.bg = theme.bg_normal_color
   presets.normal.fg = theme.fg_normal_color
   presets.low.bg = theme.bg_normal_color
   presets.low.fg = theme.fg_normal_color
   presets.normal.border_color = theme.bg_focus_color
   presets.low.border_color = theme.bg_focus_color
   presets.critical.border_color = theme.motive
   presets.critical.bg = theme.bg_normal_color
   presets.critical.fg = theme.motive
end

theme.icon_theme = "awoken"
--theme.icon_theme = "UltraFlatIconsOrange"
--theme.icon_theme = ultraflatorange
return theme
