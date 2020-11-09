-------------------------------------------------------------------------------
-- action-bar.lua
--
-- Defines the action bar for a given screen.
--
-- The action bar provides the tag selection/overview display as well as
-- quick launchers for locations and general purpose apps.
--
-- Forked from version by @mewantcookieee
-------------------------------------------------------------------------------

-- System requires
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

-- Local requires
local icons = require("theme.icons")
local TagList = require("widget.tag-list")
local clickable_container = require("widget.material.clickable-container")
local mat_icon = require("widget.material.icon")

--- Create the icon for the home button
local create_home_button = function(panel)
  print("creating home button -- " .. panel.type)

  -- Icon for the home button
  local menu_icon =
    wibox.widget {
    icon = icons.menu,
    size = dpi(24),
    widget = mat_icon
  }

  -- Displays the dashboard
  local home_button =
    wibox.widget {
    wibox.widget {
      menu_icon,
      widget = clickable_container
    },
    bg = beautiful.background.hue_800 .. "66", -- beautiful.primary.hue_500,
    widget = wibox.container.background
  }

  home_button:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          panel:toggle()
        end
      )
    )
  )

  -- Set the icon to close, when the panel is opened
  panel:connect_signal(
    "opened",
    function()
      menu_icon.icon = icons.close
    end
  )

  -- Set the icon back to the home menu button on close
  panel:connect_signal(
    "closed",
    function()
      menu_icon.icon = icons.menu
    end
  )

  return home_button, menu_icon
end

--- Create an imagebox widget which will contains an icon indicating which layout we're using.
--- We need one layoutbox per screen.
local LayoutBox = function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
      -- LMB: Next layout
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      ),
      -- RMB: Previous layout
      awful.button(
        {},
        3,
        function()
          awful.layout.inc(-1)
        end
      ),
      -- MWheel Up: Next Layout
      awful.button(
        {},
        4,
        function()
          awful.layout.inc(1)
        end
      ),
      -- MWheel Down: Prev Layout
      awful.button(
        {},
        5,
        function()
          awful.layout.inc(-1)
        end
      )
    )
  )
  return layoutBox
end

--- Create a new action bar on the given screen.
-- @tparam table screen the screen on which to create the panel
-- @tparam table panel the left-panel that this action bar belongs to
-- @tparam int action_bar_width the dpi based width of this action bar
local create_action_bar = function(screen, panel, action_bar_width)
  local home_button = create_home_button(panel)

  local xdg_folders_widget = require("widget.xdg-folders")
  return wibox.widget {
    {
      -- Top widgets
      home_button,
      -- Create a taglist widget
      TagList(screen),
      xdg_folders_widget,
      layout = wibox.layout.fixed.vertical
    },
    -- Empty space in the middle
    nil,
    {
      -- Bottom widgets
      LayoutBox(screen),
      layout = wibox.layout.fixed.vertical
    },
    id = "action_bar",
    layout = wibox.layout.align.vertical,
    forced_width = action_bar_width
  }
end

return create_action_bar
