local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

local right_dashboard = require('widget.right-dashboard')

-- Clock / Calendar 12h format
-- Get Time/Date format using `man strftime`
local CLOCK_FORMAT = '<span font="SFNS Display Bold 10">%l:%M %p</span>'
-- Clock / Calendar 12AM/PM fornatan font="Roboto Mono bold 11">%I\n%M</span>\n<span font="Roboto Mono bold 9">%p</span>')

local BAR_HEIGHT = 26

local create_clock_tooltip = function(widget) 
  -- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
  awful.tooltip(
    {
      objects = {widget},
      mode = 'outside',
      align = 'right',
      timer_function = function()
        return os.date("The date today is %A %B %d, %Y.")
      end,
      preferred_positions = {'right', 'left', 'top', 'bottom'},
      margin_leftright = dpi(8),
      margin_topbottom = dpi(8)
    }
  )
end

local cal_shape = function(cr, width, height)
  -- gears.shape.infobubble(cr, width, height, 12)
  gears.shape.partially_rounded_rect(
    cr, width, height, false, false, true, true, 12)
end

--- Create a new Clock widget on the given screen
local create_clock_widget = function(s) 
  local textclock = wibox.widget.textclock(CLOCK_FORMAT, 1)

  local clock_widget = wibox.container.margin(textclock, dpi(0), dpi(0))

  create_clock_tooltip(clock_widget)

  -- Calendar Widget
  local month_calendar = awful.widget.calendar_popup.month({
    start_sunday = true,
    spacing = 10,
    screen = s,
    font = 'SFNS Display 10',
    long_weekdays = true,
    margin = 0, -- 10
    style_month = { border_width = 0, shape = cal_shape, padding = 25},
    style_header = { border_width = 0, bg_color = '#00000000'},
    style_weekday = { border_width = 0, bg_color = '#00000000' },
    style_normal = { border_width = 0, bg_color = '#00000000'},
    style_focus = { border_width = 0, bg_color = beautiful.primary.hue_500 },
  })
  -- Attach calentar to clock_widget
  month_calendar:attach(clock_widget, "tc" , { on_pressed = true, on_hover = false })

  return clock_widget
end

-- Create to each screen
_G.screen.connect_signal("request::desktop_decoration", function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  s.systray.opacity = 0.3
  beautiful.systray_icon_spacing = 16
end)


-- Execute only if system tray widget is not loaded
_G.awesome.connect_signal("toggle_tray", function()
  if not require('widget.systemtray') then
    if awful.screen.focused().systray.visible ~= true then
      awful.screen.focused().systray.visible = true
    else
      awful.screen.focused().systray.visible = false
    end
  end
end)

-- The `+` sign in top panel
local add_button = mat_icon_button(mat_icon(icons.plus, dpi(16))) -- add button -- 24
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)


--- Creates the new top panel widget
-- @tparam s The screen to create the top panel on
-- @param offset true/false, offset due to action bar?
local TopPanel = function(s, offset)
  local offsetx = 0
  local target_screen = s
  if offset == true then
    offsetx = dpi(45)
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      type = 'dock',
      height = dpi(BAR_HEIGHT),
      width = s.geometry.width - offsetx,
      x = s.geometry.x + offsetx,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(BAR_HEIGHT)
      }
    }
  )

  panel:struts(
    {
      top = dpi(BAR_HEIGHT)
    }
  )

  panel:setup {
    expand = "none",
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      TaskList(s),
      add_button
    },
	  -- Clock
    -- Change to `nil` if you want to extend tasklist up to the right
	  create_clock_widget(s),
    {
      layout = wibox.layout.fixed.horizontal,
      s.systray,
      require('widget.systemtray'),
      require('widget.package-updater'),
      require('widget.music'),
      require('widget.bluetooth'),
      require('widget.wifi'),
      require('widget.battery'),
      require('widget.search'),
      right_dashboard(s),
    }
  }

  return panel
end

return TopPanel