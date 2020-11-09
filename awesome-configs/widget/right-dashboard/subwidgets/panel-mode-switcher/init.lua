local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local gtable = require("gears.table")
local beautiful = require("beautiful")

local HOME = os.getenv("HOME")

local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi
local clickable_container = require("widget.material.clickable-container")
local PATH_TO_ICONS = HOME .. "/.config/awesome/widget/right-dashboard/icons/"
local mat_list_item = require("widget.material.list-item")

local active_button = "#ffffff" .. "40"
local inactive_button = "#ffffff" .. "20"

local switcher = {mt = {}}

function switcher:switch_mode(right_panel_mode)
  if right_panel_mode == "notif_mode" then
    -- Update button color
    self._private.notif_widget.bg = active_button
    self._private.wrap_widget.bg = inactive_button
  elseif right_panel_mode == "widgets_mode" then
    -- Update button color
    self._private.notif_widget.bg = inactive_button
    self._private.wrap_widget.bg = active_button
  else return
  end
  print("emitting signal 'mode_change': " .. right_panel_mode)
  self:emit_signal("mode_change", right_panel_mode)
end

local function create_wrap_widget(cb)
  local widgets_text =
    wibox.widget {
    text = "Widgets",
    font = "SFNS Display Regular 10",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  local widgets_button = clickable_container(wibox.container.margin(widgets_text, dpi(0), dpi(0), dpi(7), dpi(7)))

  local wrap_widget =
    wibox.widget {
    widgets_button,
    forced_width = dpi(140),
    bg = inactive_button,
    shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, beautiful.modal_radius)
    end,
    widget = wibox.container.background
  }
  widgets_button:buttons(gears.table.join(awful.button({}, 1, nil, cb)))
  return wrap_widget
end

local function create_notif_widget(cb)
  local notif_text =
    wibox.widget {
    text = "Notifications",
    font = "SFNS Display Regular 10",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  local notif_button = clickable_container(wibox.container.margin(notif_text, dpi(0), dpi(0), dpi(7), dpi(7)))

  local wrap_notif =
    wibox.widget {
    notif_button,
    forced_width = dpi(140),
    bg = active_button,
    shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, beautiful.modal_radius)
    end,
    widget = wibox.container.background
  }

  notif_button:buttons(gears.table.join(awful.button({}, 1, nil, cb)))

  return wrap_notif
end

local function new()
  local w = { _private = {} }
  local notif_widget =
    create_notif_widget(
    function()
      w:switch_mode("notif_mode")
    end
  )

  local wrap_widget =
    create_wrap_widget(
    function()
      w:switch_mode("widgets_mode")
    end
  )

  local widget =
    wibox.widget {
    expand = "none",
    layout = wibox.layout.fixed.horizontal,
    {
      notif_widget,
      layout = wibox.layout.fixed.horizontal
    },
    {
      wrap_widget,
      layout = wibox.layout.fixed.horizontal
    }
  }
  gtable.crush(w, widget, true)
  gtable.crush(w, switcher, true)

  w._private.notif_widget = notif_widget
  w._private.wrap_widget = wrap_widget
  
  return w
end

function switcher.mt:__call(...)
  return new(...)
end

return setmetatable(switcher, switcher.mt)
