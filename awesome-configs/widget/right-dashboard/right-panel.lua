local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local mode_switcher = require("widget.right-dashboard.subwidgets.panel-mode-switcher")
local HOME = os.getenv("HOME")

local dpi = require("beautiful").xresources.apply_dpi

panel_visible = false;

local right_panel = function(screen)
  local panel_width = dpi(350, screen)
  print("Creating right panel with width " .. panel_width)
  print("Screen geometry " .. screen.geometry.width .. "x" .. screen.geometry.height)
  print("Creating panel at " .. screen.geometry.x + screen.geometry.width - panel_width .. ", " .. screen.geometry.y)
  local panel =
    wibox {
    ontop = true,
    screen = screen,
    type = "dock",
    width = panel_width,
    height = screen.geometry.height,
    x = screen.geometry.x + screen.geometry.width - panel_width,
    y = screen.geometry.y,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }

  panel.opened = false

  local switcher = mode_switcher()

  local backdrop =
    wibox {
    ontop = true,
    screen = screen,
    bg = "#00000000",
    type = "utility",
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  panel:struts(
    {
      right = 0
    }
  )
  local openPanel = function()
    panel_visible = true
    backdrop.visible = true
    panel.visible = true
    panel:emit_signal("opened")
  end

  local closePanel = function()
    panel_visible = false
    panel.visible = false
    backdrop.visible = false
    -- Change to notif mode on close
    panel:emit_signal("closed")
  end

  -- Hide this panel when app dashboard is called.
  function panel:hideDashboard()
    closePanel()
  end

  function panel:toggle()
    self.opened = not self.opened
    if self.opened then
      openPanel()
    else
      closePanel()
    end
  end

  local debug = require("gears.debug")
  function panel:switch_mode(mode)
    debug.dump(mode, "mode")
    print("panel switching to mode " .. mode)
    if mode == "notif_mode" then
      -- Update Content
      panel:get_children_by_id("notif_id")[1].visible = true
      panel:get_children_by_id("widgets_id")[1].visible = false
    elseif mode == "widgets_mode" then
      -- Update Content
      panel:get_children_by_id("notif_id")[1].visible = false
      panel:get_children_by_id("widgets_id")[1].visible = true
    end
  end

  switcher:connect_signal("mode_change", function(_, m) panel:switch_mode(m) end)


  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  local separator =
    wibox.widget {
    orientation = "horizontal",
    opacity = 0.0,
    forced_height = 15,
    widget = wibox.widget.separator
  }

  local line_separator =
    wibox.widget {
    orientation = "horizontal",
    forced_height = 15,
    span_ratio = 1.0,
    opacity = 0.90,
    color = beautiful.bg_modal,
    widget = wibox.widget.separator
  }

  panel:setup {
    expand = "none",
    layout = wibox.layout.fixed.vertical,
    separator,
    {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      nil,
      switcher,
      nil
    },
    separator,
    line_separator,
    {
      layout = wibox.layout.stack,
      -- Notification Center
      {
        id = "notif_id",
        visible = true,
        separator,
        {
          {
            layout = wibox.layout.fixed.vertical,
            require("widget.notif-center")
          },
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.vertical
      },
      -- Widget Center
      {
        id = "widgets_id",
        visible = false,
        layout = wibox.layout.fixed.vertical,
        separator,
        {
          {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(10),
            require("widget.user-profile"),
            require("widget.email"),
            require("widget.weather"),
            require("widget.calculator")
          },
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin
        }
      }
    }
  }

  return panel
end

return right_panel
