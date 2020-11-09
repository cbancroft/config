-------------------------------------------------------------------------------
-- tag-list.lua
--
-- Defines the tag list used by the wibox
--
-- Forked from version by @mewantcookieee
-------------------------------------------------------------------------------

-- Awesome requires
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local capi = {button = _G.button}

-- local requires
local clickable_container = require("widget.material.clickable-container")
local modkey = require("configuration.keys.mod").modKey

--- Common method to create buttons.
-- @tab buttons
-- @param object
-- @treturn table
local function create_buttons(buttons, object)
  if buttons then
    local btns = {}
    for _, b in ipairs(buttons) do
      -- Create a proxy button object: it will receive the real
      -- press and release events, and will propagate them to the
      -- button object the user provided, but with the object as
      -- argument.
      local btn = capi.button {modifiers = b.modifiers, button = b.button}
      btn:connect_signal(
        "press",
        function()
          b:emit_signal("press", object)
        end
      )
      btn:connect_signal(
        "release",
        function()
          b:emit_signal("release", object)
        end
      )
      btns[#btns + 1] = btn
    end

    return btns
  end
end

--- Update the display list as running applications change

local function list_update(w, buttons, label, data, objects)
  -- update the widgets, creating them if needed
  w:reset()
  for i, o in ipairs(objects) do
    local cache = data[o]
    local imagebox, textbox, background_box, textbox_margin, imagebox_margin, l, bg_clickable
    if cache then
      imagebox = cache.ib
      textbox = cache.tb
      background_box = cache.bgb
      textbox_margin = cache.tbm
      imagebox_margin = cache.ibm
    else
      local icondpi = 10 -- CUSTOM VARIABLE
      imagebox = wibox.widget.imagebox()
      textbox = wibox.widget.textbox()
      background_box = wibox.container.background()
      textbox_margin = wibox.container.margin(textbox, dpi(4), dpi(16))
      imagebox_margin = wibox.container.margin(imagebox, dpi(icondpi), dpi(icondpi), dpi(icondpi), dpi(icondpi)) -- ALL 12
      l = wibox.layout.fixed.horizontal()
      bg_clickable = clickable_container()

      -- All of this is added in a fixed widget
      l:fill_space(true)
      l:add(imagebox_margin)
      -- l:add(tbm)
      bg_clickable:set_widget(l)

      -- And all of this gets a background
      background_box:set_widget(bg_clickable)

      background_box:buttons(create_buttons(buttons, o))

      data[o] = {
        ib = imagebox,
        tb = textbox,
        bgb = background_box,
        tbm = textbox_margin,
        ibm = imagebox_margin
      }
    end

    local text, bg, bg_image, icon, args = label(o, textbox)
    args = args or {}

    -- The text might be invalid, so use pcall.
    if text == nil or text == "" then
      textbox_margin:set_margins(0)
    else
      if not textbox:set_markup_silently(text) then
        textbox:set_markup("<i>&lt;Invalid text&gt;</i>")
      end
    end
    background_box:set_bg(bg)
    if type(bg_image) == "function" then
      -- TODO: Why does this pass nil as an argument?
      bg_image = bg_image(textbox, o, nil, objects, i)
    end
    background_box:set_bgimage(bg_image)
    if icon then
      imagebox.image = icon
    else
      imagebox_margin:set_margins(0)
    end

    background_box.shape = args.shape
    background_box.shape_border_width = args.shape_border_width
    background_box.shape_border_color = args.shape_border_color

    w:add(background_box)
  end
end

local TagList = function(s)
  return awful.widget.taglist(
    {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = awful.util.table.join(
        -- LMB: View this tag
        awful.button(
          {},
          1,
          function(t)
            t:view_only()
          end
        ),
        -- Mod4 + LMB: Move active and view
        awful.button(
          {modkey},
          1,
          function(t)
            if _G.client.focus then
              _G.client.focus:move_to_tag(t)
              t:view_only()
            end
          end
        ),
        -- RMB: Toggle this tag
        awful.button({}, 3, awful.tag.viewtoggle),
        -- Mod4 + RMB: Toggle this client on this tag
        awful.button(
          {modkey},
          3,
          function(t)
            if _G.client.focus then
              _G.client.focus:toggle_tag(t)
            end
          end
        ),
        -- MWheelUp: Previous tag
        awful.button(
          {},
          4,
          function(t)
            awful.tag.viewprev(t.screen)
          end
        ),
        -- MWheelDown: Next tag
        awful.button(
          {},
          5,
          function(t)
            awful.tag.viewnext(t.screen)
          end
        )
      ),
      style = {},
      update_function = list_update,
      layout = wibox.layout.fixed.vertical()
    }
  )
end
return TagList
