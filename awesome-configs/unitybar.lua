----------
--- Unity bar module
--
-- @author Charles Bancroft
-- Based on the unity bar at https://github.com/alexander-yakushev/awesomerc/blob/master/topjets/unitybar.lua
----------

-- Grab needed environment
local capi = { screen = screen,
	       awesome = awesome,
	       client = client,
	       button = button}
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local table = table
local common = require("awful.widget.common")
local util = require("awful.util")
local button = require("awful.button")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local fixed = require("wibox.layout.fixed")
local wlayout = require("wibox.layout")
local wcontainer = require("wibox.container")
local surface = require("gears.surface")
local timer = require("gears.timer")
local awtaglist = require("awful.widget.taglist")
local widget = require("wibox.widget")
local bag = require("bag")
local gears = require("gears")
local iconic = require("iconic")
local dpi = beautiful.xresources.apply_dpi
local function get_screen(s)
   return s and capi.screen[s]
end

local unitybar = { mt = {} }
unitybar.filter = {}

local instances = nil
function unitybar.create_buttons(buttons, object)
   if buttons then
      local btns = {}
      for _, b in ipairs(buttons) do
	 -- Create a proxy button object: it will receive the real
	 -- press and release events, and will propagate them to the
	 -- button object the user provided, but with the object as
	 -- argument.
	 local btn = capi.button { modifiers = b.modifiers, button = b.button }
	 btn:connect_signal("press", function () b:emit_signal("press", object) end)
	 btn:connect_signal("release", function () b:emit_signal("release", object) end)
	 btns[#btns + 1] = btn
      end

      return btns
   end
end

function unitybar.unitybar_label(t, args )
   if not args then
      args = {}
   end
   local theme = beautiful.get()
   local fg_focus = args.fg_focus or theme.taglist_fg_focus or theme.fg_focus
   local bg_focus = args.bg_focus or theme.taglist_bg_focus or theme.bg_focus

   local bg_color = nil
   local fg_color = nil

   if t.selected then
      print("Tag", t.name, "is selected")
      bg_color = bg_focus
      fg_color = fg_focus
   end
   print("Labelling tag ", t.name, " with color ",bg_color)
   text = "<span>" .. (util.escape(t.name) or "") .. "</span>"
   return text, bg_color, nil, nil, nil
end

local task_entry_buttons = util.table.join(
   button({}, 1, function(te)
	 if te.tag then te.tag:view_only() end
	 te.client:raise()
	 client.focus = te.client
   end)
)

local tag_buttons = util.table.join(
   button({}, 1, function(t)
	 if t then t:view_only() end
		 end
   )
)

local function build_styling(style)
   if not style then style = {} end
   local theme = beautiful.get()
   local styling = {}
   styling.vertical = style.vertical or false

   styling.fg_normal = util.ensure_pango_color(style.fg_normal or theme.fg_normal, "white")
   styling.bg_urgent = util.ensure_pango_color(style.bg_urgent or theme.bg_urgent, "red")
   styling.thin = style.thin or false
   styling.width = style.width or dpi(60)
   styling.default_icon = style.default_icon or iconic.lookup_icon("application_default_icon")

   if styling.thin then
      styling.unfocused_size = math.floor( (styling.width - dpi(4)) / 2 )
      styling.focused_size = styling.width - dpi(4) - dpi(1)
   else
      styling.unfocused_size = math.max(math.floor((styling.width - dpi(5))/dpi(3)), dpi(18))
      styling.focused_size = styling.width - dpi(8) - styling.unfocused_size - dpi(1)
   end
   return styling
end

local function unitybar_update_tagwidget( t, w, style )
   print("Updating tagwidget ", t.name)
   w:reset()

   local visible_clients, pivot, urgent = {}, 0, false

   for _, c in ipairs(t:clients()) do
      if not (c.skip_taskbar or c.hidden
		 or c.type == "splash" or c.type == "dock" or c.type == "desktop")
      then
	 local im = widget.imagebox()
	 local entry = {
	    tag = t,
	    client = c,
	 }
	 im:set_image(c.icon)
	 im.client = c
	 im:buttons(unitybar.create_buttons(task_entry_buttons, entry))
	 print( "Creating button box for", c.name)
	 table.insert(visible_clients, im)

	 if client.focus == c then
	    pivot = #visible_clients
	 end
	 if c.urgent then
	    urgent = true
	 end
      end
   end

   local middle = widget {
      nil,
      nil,
      nil,
      layout = wlayout.align.horizontal
   }
   print("Tag Selected:", t.selected)
   local bgb = widget {
      {
	 middle,
	 margins = dpi(2),
	 layout = wcontainer.margin,
      },
      color = urgent and style.bg_urgent or '#ff0000',
      border = t.selected,
      widget = wcontainer.background,
      shape = function(cr, width, height)
	 if t.selected then
	    gears.shape.rounded_rect(cr, width, height, 5)
	 end
      end,
      shape_border_width = 1,
      shape_border_color = '#ffffffff',
   }

   w.widget = bgb

   if #visible_clients == 0 then
      local num = widget.textbox()
      num.align = "center"
      num.valign = "center"
      num:buttons(unitybar.create_buttons(tag_buttons, t))
      -- TODO: Set up buttons!
      num:set_markup_silently(string.format('<span>%s</span>',t.name))
      middle.second = widget {
	 nil,
	 num,
	 nil,
	 layout = wlayout.align.horizontal

      }

      return
   end

   if pivot ~= 0 then
      local back = bag.new {}
      local content = widget {
	 {
	    nil,
	    {
	       visible_clients[pivot],
	       width = style.focused_size,
	       height = style.focused_size,
	       strategy = 'exact',
	       widget = wcontainer.constraint
	    },
	    nil,
	    expand = "outside",
	    layout = wlayout.align.vertical
	 },
	 (#visible_clients > 1) and back or nil,
	 fill_space = true,
	 layout = wlayout.fixed.horizontal
      }
      middle.second = content

      for i = pivot - 1, 1, -1 do
	 print("Adding client ", visible_clients[i].client.name, "to bag")
	 back:add(widget {
		     visible_clients[i],
		     width = style.unfocused_size,
		     height = style.unfocused_size,
		     strategy = 'exact',
		     widget = wcontainer.constraint
	 })

      end

      for i = #visible_clients, pivot + 1, -1 do

	 print("Adding client ", visible_clients[i].client.name, "to bag")
	 back:add( widget {
		      visible_clients[i],
		      width = style.unfocused_size,
		      height = style.unfocused_size,
		      strategy = 'exact',
		      widget = wcontainer.constraint
	 })

      end
   else
      local apps = bag.new {}
      middle.second = apps
      for i = 1, #visible_clients do

	 print("Adding client", visible_clients[i].client.name, "to bag")
	   apps:add( widget {
		      visible_clients[i],
		      width = style.unfocused_size,
		      height = style.unfocused_size,
		      strategy = 'exact',
		      widget = wcontainer.constraint
	   })

      end
   end
end

local function unitybar_update(s, w, buttons, filter, data, style)
   w:reset()
   for _, t in ipairs(s.tags) do
      if not tag.getproperty(t, "hide") and filter(t) then
	 tag_widget = wcontainer.constraint()
	 tag_container = widget {
	    {
	       tag_widget,
	       margins=dpi(2),
	       layout = wcontainer.margin
	    },
	    widget = wcontainer.constraint,
	    strategy = 'exact',
	    width = style.thin and (style.width * 3) or style.width,
	    height = style.width,
	 }

	 data[t] = {
	    widget = tag_widget,
	    container = tag_container,
	 }
	 w:add(tag_container)
	 unitybar_update_tagwidget( t, tag_widget, style )

      end
   end
end

function unitybar.new(screen, filter, buttons, style, base_widget)
--   local w = awtaglist( screen, awtaglist.filter.all, taglist_buttons, style, unitybar_update, base_widget)
   local screen = get_screen(screen)
   local style = build_styling(style)
   local w = base_widget or (style.vertical and fixed.vertical() or fixed.horizontal())

   print "Creating new unitybar"
--   if w.set_spacing and (style and style.spacing or beautiful.unitybar_spacing) then
--      w:set_spacing(style and style.spacing or beautiful.unitybar_spacing)
--   end

   local data = setmetatable({}, { __mode = 'k' })

   local queued_update = {}

   -- Called when a unitybar update needs to happen.  Will swallow multiple
   -- simultaneous calls until one is handled
   function w._do_unitybar_update()
      -- Add a delayed callback for the first update
      if not queued_update[screen] then
	 timer.delayed_call(function()
	       if screen.valid then
		  unitybar_update(screen, w, buttons, filter, data, style)
	       end
	       queued_update[screen] = false
	 end)
	 queued_update[screen] = true
      end
   end

   -- Flushes client data when a window is closed
   function w._unmanage(c)
      data[c] = nil
   end

   if instances == nil then
      instances = setmetatable({}, { __mode = "k" })
      local function u(s)
	 local i = instances[get_screen(s)]
	 if i then
	    for _, ub in pairs(i) do
	       ub._do_unitybar_update()
	    end
	 end
      end

      local uc = function (c) return u(c.screen) end
      local ut = function (t) return u(t.screen) end

      capi.client.connect_signal("focus", uc)
      capi.client.connect_signal("unfocus", uc)

      tag.attached_connect_signal(nil, "property::selected", ut)
      tag.attached_connect_signal(nil, "property::icon", ut)
      tag.attached_connect_signal(nil, "property::hide", ut)
      tag.attached_connect_signal(nil, "property::name", ut)
      tag.attached_connect_signal(nil, "property::activated", ut)
      tag.attached_connect_signal(nil, "property::screen", ut)
      tag.attached_connect_signal(nil, "property::index", ut)
      tag.attached_connect_signal(nil, "property::urgent", ut)
      capi.client.connect_signal("property::screen", function(c, old_screen)
				    u(c.screen)
				    u(old_screen)
      end)
      capi.client.connect_signal("tagged", uc)
      capi.client.connect_signal("untagged", uc)
      capi.client.connect_signal("unmange", uc)
      capi.client.connect_signal("removed", function(s)
				    instances[get_screen(s)] = nil
      end)
   end

   w._do_unitybar_update()

   local list = instances[screen]
   if not list then
      list = setmetatable({}, { __mode = "v" })
      instances[screen] = list
   end
   table.insert(list, w)
   return w
end

function unitybar.mt:__call(...)
   return unitybar.new(...)
end

return setmetatable(unitybar, unitybar.mt)
