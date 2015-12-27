-- Standard awesome library
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
scheduler = require('scheduler')
private = require('private')
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Theme handling library
local beautiful = require('beautiful')
-- Notification library
naughty = require("naughty")
-- Logging library
log = require("log")
-- Quake console
local quake = require("quake")
-- Menubar
local menubar = require("menubar")
-- Utility
local utility = require("utility")
-- Dictionary
local dict = require("dict")
-- Thinkpad specific features
local lenovo = require('lenovo')

local minitray = require('minitray')
local statusbar = require('statusbar')

--local lustrous = require('lustrous')
local smartmenu = require('smartmenu')

local lain = require("lain")
-- Map useful functions outside
calc = utility.calc
notify_at = utility.notify_at

userdir = utility.pslurp("echo $HOME", "*line")

-- Autorun programs
autorunApps = {
   "setxkbmap -layout 'us' -variant ',winkeys,winkeys' -option grp:menu_toggle -option compose:ralt -option terminate:ctrl_alt_bksp",
   'sleep 2; xmodmap ~/.xmodmap'
}

runOnceApps = {
   'thunderbird',
   'xrdb -merge ~/.Xresources',
   'pulseaudio --start',
   'redshift -l 60.8:10.7 -m vidmode -g 0.8 -t 6500:5000'
}

utility.autorun(autorunApps, runOnceApps)

-- Various initialization
lenovo.touchpad.enable(false)

-- lustrous.init { lat = private.user.loc.lat,
--                lon = private.user.loc.lon,
--                offset = private.user.time_offset }
--

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/serenity/theme.lua")
--beautiful.init(awful.util.getdir("config") .. "/themes/devotion/theme.lua")
beautiful.onscreen.init()
-- {{{ Wallpaper
for s = 1, screen.count() do
   gears.wallpaper.maximized( beautiful.wallpaper[s], s, true)
end
-- }}}

-- Default system software
software = { terminal = "termite",
             terminal_cmd = "termite -e ",
             editor = "emacsclient",
             editor_cmd = "emacsclient -n -c ",
             browser = "google-chrome-stable --force-device-scale-factor=1",
             browser_cmd = "google-chrome-stable --force-device-scale=factor=1" }

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
   awful.layout.suit.floating, 	        -- 1
   lain.layout.uselesstile, 		-- 2
   awful.layout.suit.tile.bottom,	-- 3
   awful.layout.suit.max.fullscreen,
   lain.layout.uselesspiral,
   lain.layout.uselessfair,
   lain.layout.centerwork,
   lain.layout.cascadetile,
   lain.layout.termfair,
   lain.layout.cascade
}
awful.layout.layouts = layouts
-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
do
   local f, t, b, fs = layouts[1], layouts[2], layouts[3], layouts[4]
   for s = 1, screen.count() do
      -- Each screen has its own tag table.
      tags[s] = awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 "}, s,
                          {  t ,  t ,  f ,  f ,  f ,  f ,  f ,  f })
   end
end
-- }}}

-- Right statusbar
for s = 1, screen.count() do
   statusbar.create(s)
end

-- Configure menubar
menubar.cache_entries = true
menubar.utils.terminal = software.terminal
menubar.app_folders = { "/usr/share/applications/" }
menubar.show_categories = true

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
globalkeys = awful.util.table.join(
   -- {{{ Applications
   awful.key({ modkey }, "e", function () awful.util.spawn(software.editor_cmd) end),
   awful.key({ modkey }, "w", function () awful.util.spawn(software.browser) end),
   awful.key({ altkey }, "F1",  function () awful.util.spawn(software.terminal) end),
   awful.key({ modkey }, "q", function () utility.spawn_in_terminal("emacsclient --eval '(make-capture-frame)'") end),
   awful.key({ modkey }, "t", function () utility.spawn_in_terminal("thunderbird") end),
   awful.key({ altkey }, "F12", function () utility.spawn_in_terminal("slimlock") end),
   awful.key({ modkey, "Shift"   }, "p", function() menubar.show() end ),
   awful.key({ modkey,           }, "l", minitray.toggle ),
   awful.key({ modkey,           }, "Return", function () quake.toggle({ terminal = software.terminal,
                                                                         name = "QuakeTermite",
									 argname = "--name %s",
                                                                         height = 0.25,
                                                                         skip_taskbar = true,
                                                                         ontop = true })
                                              end),
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
		awful.util.eval(awful.util.escape(awful.util.restart()))
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
   awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end),
   awful.key({ modkey },          "space", function () 
		awful.layout.inc(1) 
		naughty.notify {title = 'Layout changed',
				text = 'Current layout: ' .. awful.layout.get(mouse.screen).name,
		} end),

   awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1)  end),
   awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
   awful.key({ modkey,         }, "p", function () awful.screen.focus_relative(1)  end),
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

		 local tags = awful.tag.gettags(mouse.screen)
		 for _, t in ipairs(tags) do
		       for _, c in ipairs(t:clients()) do
			  if c.maximized_horizontal then
			     c.maximized_horizontal = false
			     c.maximized_horizontal = true
			  end
			  if c.maximized_vertical then
			     c.maximized_vertical = false
			     c.maximized_vertical = true
			  end
		       end
		 end
			     end )
   -- }}}
)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey,           }, "o",      smart_movetoscreen                        ),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
             function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
             end),
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
             end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
   globalkeys = awful.util.table.join(globalkeys,
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
                                      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                                function ()
                                                   if client.focus and tags[client.focus.screen][i] then
                                                      awful.client.toggletag(tags[client.focus.screen][i])
                                                   end
                                                end))
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

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
     properties = { callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end} },
   { rule = { class = "Chromium",  instance = "chromium" },
     properties = { callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end} },
   { rule = { role = "browser" },
     properties = { callback = function(c) awful.client.movetotag(tags[mouse.screen][3], c) end} },
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
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
                      function (c, startup)
                         -- Enable sloppy focus
                         c:connect_signal("mouse::enter",
                                          function(c)
                                             if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                                and awful.client.focus.filter(c) then
                                             client.focus = c
                                             end
                                          end)

                         if not startup then
                            -- Set the windows at the slave,
                            -- i.e. put it at the end of others instead of setting it master.
                            -- awful.client.setslave(c)

                            -- Put windows in a smart way, only if they does not set an initial position.
                            if not c.size_hints.user_position and not c.size_hints.program_position then
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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

scheduler.start()
-- }}}
