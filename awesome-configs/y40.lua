
-- {{{ License
--
-- Awesome configuration, using awesome 3.5 on Arch GNU/Linux
--   * Charles B. <charlie.bancroft@gmail.com>

-- Parts borrow from anrxc's configuration:
--   * http://git.sysphere.org/awesome-configs
-- Parts also borrowed from Alex Yakushevs configs at
--   * https://github.com/alexander-yakushev/awesomerc
-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Libraries

-- Wibox is no longer part of standard library
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
scheduler = require('scheduler')
private = require('private')
awful.rules = require("awful.rules")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
log = require('log')
local menubar = require("menubar")
local utility = require('utility')
local dict = require("dict")
local lenovo = require('lenovo')
local minitray = require('minitray')
local statusbar = require('statusbar')
local picturesque = require('picturesque')
local lustrous = require('lustrous')
local smartmenu = require('smartmenu')

-- }}}

-- Map useful functions ??
calc = utility.calc
notify_at = utility.notify_at

userdir = utility.pslurp("echo $HOME", "*line")


-- Handle runtime errors after startup


-- Autorun some stuff on startup
autorunApps = {
   "setxbmap -layout 'us' -option terminate:ctrl_alt_bksp", 
   "sleep 2; xmodmap ~/.xmodmap"
}

runOnceApps = {
   'thunderbird',
   'spotify',
   'pulseaudio --start',
   'redshift -l 60.8:10.7 -m vidmode -g 0.8 -t 6500:5000',
}

utility.autorun( autorunApps, runOnceApps )

--lustrous
lustrous.init { lat = private.user.loc.lat,
	       lon = private.user.loc.lon,
	       offset = private.user.time_offset }

-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/themes/serenity/theme.lua")
beautiful.onscreen.init()

-- Wallpaper 
picturesque.sfw = true
scheduler.register_recurring("picturesque", 1800, picturesque.change_image)


-- {{{ Variable definitions
software = {
   terminal = "urxvtc",
   terminal_cmd = "urxvtc -e ",
   editor = "emacsclient",
   browser = "google-chrome-beta",
   browser_cmd = "google-chrome-beta "}

altkey = "Mod1"
modkey = "Mod4"

-- Window management layouts
local layouts = {
  awful.layout.suit.tile,        -- 1
  awful.layout.suit.tile.bottom, -- 2
  awful.layout.suit.floating,     -- 3
  awful.layout.suit.max.fullscreen -- 4
}
-- }}}


-- {{{ Tags
tags = {}
do
   local f, t, b, fs = layouts[3], layouts[1], layouts[2], layouts[4]
   for s = 1, screen.count() do
      -- Tag table per screen
      tags[s] = awful.tag( {"1","2","3","4","5","6"}, s,
			   { t,t,t,f,f,f})
   end
end
-- }}}

--Right statusbar
for s = 1, screen.count() do
   statusbar.create(s)
end

-- Configure menubar
menubar.cache_entries = true
menubar.app_folders = {"/usr/share/applications/"}
menubar.show_categories = true

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Interact with snap script

function snap ( filename )
   naughty.notify { title = "Screenshot captured: " .. filename:match ( ".+/(.+)" ),
                    text = "Left click to upload",
                    timeout = 10,
                    icon_size = 200,
                    icon = filename,
                    run = function (notif)
                       asyncshell.request ( "imgurbash " .. filename,
                                            function (f)
                                               local t = f:read()
                                               f:close()
                                               naughty.notify { title = "Image uploaded",
                                                                text = t,
                                                                run = function (notif)
                                                                   os.execute ( "echo " .. t .. " | xclip " )
                                                                   naughty.destroy(notif)
                                                                end }
                                            end )
                       naughty.destroy(notif)
                    end }
end

--- Smart Move a client to a screen. Default is next screen, cycling.
-- @param c The client to move.
-- @param s The screen number, default to current + 1.
function smart_movetoscreen(c, s)
   local was_maximized = { h = false, v = false }
   if c.maximized_horizontal then
      c.maximized_horizontal = false
      was_maximized.h = true
   end
   if c.maximized_vertical then
      c.maximized_vertical = false
      was_maximized.v = true
   end

   local sel = c or client.focus
   if sel then
      local sc = screen.count()
      if not s then
         s = sel.screen + 1
      end
      if s > sc then s = 1 elseif s < 1 then s = sc end
      sel.screen = s
      mouse.coords(screen[s].geometry)
   end

   if was_maximized.h then
      c.maximized_horizontal = true
   end
   if was_maximized.v then
      c.maximized_vertical = true
   end
end

-- {{{ Key bindings
--
-- {{{ Global keys
globalkeys = awful.util.table.join(
   -- {{{ Applications
   awful.key({ modkey }, "e", function () awful.util.spawn("emacsclient -n -c") end),
   awful.key({ modkey }, "w", function () utility.spawn_in_terminal(software.browser) end),
   awful.key({ altkey }, "F1",  function () awful.util.spawn("urxvtc") end),
   awful.key({ modkey }, "q", function () utility.spawn_in_terminal("emacsclient --eval '(make-capture-frame)'") end),
   awful.key({ modkey }, "t", function () utility.spawn_in_terminal("thunderbird") end),
   awful.key({ altkey }, "F12", function () utility.spawn_in_terminal("slimlock") end),
   -- }}}
   
   -- {{{ Multimedia keys
   awful.key({}, "XF86AudioMute", function () 
		utility.spawn_in_terminal("/usr/bin/mute_toggle") 
				  end),
   awful.key({}, "XF86AudioLowerVolume", function () statusbar.widgets.vol:dec() end ),
   awful.key({}, "XF86AudioRaiseVolume", function () statusbar.widgets.vol:inc() end ),
   
   -- }}}
   
   -- {{{ Prompt menus
   awful.key({ modkey }, "r", function ()
		 local promptbox = statusbar.widgets.prompt[mouse.screen]
		 awful.prompt.run({ prompt = promptbox.prompt,
				    bg_cursor = beautiful.bg_focus_color },
				  promptbox.widget,
				  function (...)
				     local result = awful.util.spawn(...)
				     if type(result) == "string" then
					promptbox.widget:set_text(result)
				     end
				  end,
				  awful.completion.shell,
				  awful.util.getdir("cache") .. "/history")
			      end),
   awful.key({ modkey }, "x", function ()
		awful.prompt.run({ prompt = "Run Lua code: ",
				   bg_cursor = beautiful.bg_focus_color },
				 statusbar.widgets.prompt[mouse.screen].widget,
				 awful.util.eval, nil,
				 awful.util.getdir("cache") .. "/history_eval")
                              end),
   
   -- }}}
 
  awful.key({ modkey,           }, "=",   dict.lookup_word),

   -- {{{ Awesome controls
   awful.key({ modkey, "Shift" }, "q", awesome.quit),
   awful.key({ modkey, "Shift" }, "r", function ()
		mypromptbox[mouse.screen]:set_markup(awful.util.escape(awful.util.restart()))
				       end),
   -- }}}
   
   -- {{{ Tag browsing
   awful.key({ "Control", altkey }, "n",   awful.tag.viewnext),
   awful.key({ "Control", altkey }, "p",   awful.tag.viewprev),
   awful.key({ modkey }, "Left", function() utility.view_non_empty(-1) end ),
   awful.key({ modkey }, "Right", function() utility.view_non_empty(1) end ),
   awful.key({ modkey }, "Tab", 
	     function ()
		awful.client.focus.history.previous()
		if client.focus then
		   client.focus:raise()
		end
	     end),

   -- }}}
   
   -- {{{ Layout manipulation
   awful.key({ modkey }, "l",          function () awful.tag.incmwfact( 0.05) end),
   awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
   awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
   awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact( 0.05) end),
   awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
   awful.key({ modkey },          "space", function () 
		awful.layout.inc(layouts,  1) 
		naughty.notify {title = 'Layout changed',
				text = 'Current layout: ' .. awful.layout.get(mouse.screen).name,
		} end),

   awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1)  end),
   awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(1)  end),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    -- }}}
   
   -- {{{ Focus controls
   awful.key({ modkey }, "j", function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
			      end),
   awful.key({ modkey }, "Up", function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
			      end),
   awful.key({ modkey }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
			      end),
   awful.key({ modkey }, "Down", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
			      end),

   awful.key({ altkey }, "Escape", function ()
		awful.menu.menu_keys.down = { "Down", "Alt_L" }
		local cmenu = awful.menu.clients({width=230}, { keygrabber=true, coords={x=525, y=330} })
				   end),

   awful.key({ modkey }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey, "Control" }, "n", awful.client.restore ),
   -- }}}

   -- {{{ Other stuff
   awful.key( {modkey}, "b", function ()
		 statusbar.wiboxes[mouse.screen].visible = not statusbar.wiboxes[mouse.screen].visible
		 local clients = clients.get()
		 local curtagclients = {}
		 local tags = screen[mouse.screen]:tags()
		 for _, c in ipairs(clients) do
		    for k, t in ipairs(tags) do
		       if t.selected then 
			  local ctags = c:tags()
			  for _, v in ipairs(ctags) do
			     if v == t then
				table.insert(curtagclients, c)
			     end
			  end
		       end
		    end
		 end
		 for _, c in ipairs( curtagclients ) do
		    if c.maximized_horizontal then
		       c.maximized_horizontal = false
		       c.maximized_horizontal = true
		    end
		 end
			     end )
   -- }}}
)
-- }}}

-- {{{ Client manipulation
clientkeys = awful.util.table.join(
    awful.key({ modkey }, "c", function (c) c:kill() end),
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey, "Control" }, "Space", awful.client.floating.toggle),
    awful.key({ modkey }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey }, "o",     smart_movetoscreen ),
    awful.key({ modkey }, "t",     function(c) c.ontop = not c.ontop end),
    awful.key({ modkey }, "n",
	      function(c)
		 --Client currently has input focus, so it cannot be
		 --minimized, since clients cant have focus
		 c.minimized = true
	      end)


)
-- }}}

-- {{{ Keyboard digits
local keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- }}}

-- {{{ Tag controls
for i = 1, keynumber do
    globalkeys = awful.util.table.join( globalkeys,
					awful.key({ modkey }, "#" .. i + 9, 
						  function ()
						     local screen = mouse.screen
						     if tags[screen][i] then 
							awful.tag.viewonly(tags[screen][i]) 
						     end
						  end),
					awful.key({ modkey, "Control" }, "#" .. i + 9, 
						  function ()
						     local screen = mouse.screen
						     if tags[screen][i] then 
							awful.tag.viewtoggle(tags[screen][i]) 
						     end
						  end),
					awful.key({ modkey, "Shift" }, "#" .. i + 9, 
						  function ()
						     if client.focus and tags[client.focus.screen][i] then
							awful.client.movetotag(tags[client.focus.screen][i])
						     end
						  end),
					awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
						     if client.focus and tags[client.focus.screen][i] then
							awful.client.toggletag(tags[client.focus.screen][i])
						     end
						  end)
    )
end
-- }}}

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}

-- Set keys
statusbar.widgets.mpd:append_global_keys()
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule
   { rule = { }, properties = {
	focus = true,      
	size_hints_honor = false,
	keys = clientkeys, 
	buttons = clientbuttons,
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal }
   },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "Deluge" },
     properties = { tag = tags[screen.count() or 1][6] } },
   { rule = { class = "Transmission-gtk" },
     properties = { tag = tags[screen.count() or 1][6] } },

    { rule = { class = "Thunderbird" }, properties = { tag = tags[1][4]} },

   { rule = { class = "Skype" },
     properties = { tag = tags[screen.count() or 1][5],
                    floating = true } },

   { rule = { class = "Chromium" },
      properties = { tag = tags[1][3] } },
   { rule = { class = "Chromium",  instance = "chromium" },
     properties = { tag = tags[1][3] } },
   { rule = { role = "browser" },
     properties = { tag = tags[1][3] } },
   { rule = { class = "Emacs",    instance = "emacs" },
     properties = { tag = tags[1][2] } },
    { rule = { class = "Emacs",    instance = "_Remember_" },
      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { class = "Xmessage", instance = "xmessage" },
      properties = { floating = true }, callback = awful.titlebar.add  },
   { rule = { class = "Steam" },
     properties = { tag = tags[screen.count() or 1][7] } },
    { rule = { class = "Ark" },         properties = { floating = true } },
    { rule = { class = "Geeqie" },      properties = { floating = true } },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Pinentry.*" },  properties = { floating = true } },

    { rule = { class = "llpp" },
      properties = { tag = tags[1][5], sticky=false } },

    { rule = { class = "feh" },
      properties = { floating = true }},
}
-- }}}


-- {{{ Signals
--
-- {{{ Manage signal handler
client.connect_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    --if awful.client.floating.get(c) then
    --or awful.layout.get(c.screen) == awful.layout.suit.floating then
--		toggle_titlebar(c)
--    end

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
       -- Widgets that are aligned to the left
       local left_layout = wibox.layout.fixed.horizontal()
       left_layout:add(awful.titlebar.widget.iconwidget(c))

       -- Widgets that are aligned to the right
       local right_layout = wibox.layout.fixed.horizontal()
       right_layout:add(awful.titlebar.widget.floatingbutton(c))
       right_layout:add(awful.titlebar.widget.maximizedbutton(c))
       right_layout:add(awful.titlebar.widget.stickybutton(c))
       right_layout:add(awful.titlebar.widget.ontopbutton(c))
       right_layout:add(awful.titlebar.widget.closebutton(c))
       
       -- The title goes in the middle
       local title = awful.titlebar.widget.titlewidget(c)
       title:buttons(awful.util.table.join(
			awful.button({ }, 1, function()
					client.focus = c
					c:raise()
					awful.mouse.client.move(c)
					     end),
			awful.button({ }, 3, function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
					     end)
					  ))
       
       -- Now bring it all together
       local layout = wibox.layout.align.horizontal()
       layout:set_left(left_layout)
       layout:set_right(right_layout)
       layout:set_middle(title)
			    
       awful.titlebar(c):set_widget(layout)
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.connect_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}


scheduler.start()
