-- Standard awesome library
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
-- Notification library
naughty = require("naughty")
-- Logging library
log = require("log")
scheduler = require('scheduler')
private = require('private')
vista = require("vista")
require("awful.autofocus")
-- Theme handling library
local beautiful = require('beautiful')

-- Utility
local utility = require("utility")
local cmd = utility.cmd
userdir = utility.pslurp("echo $HOME", "*line")

local quake = require("quake")
local currencies = require("currencies")
local dict = require("dict")
local minitray = require('minitray')
local statusbar = require('statusbar')
local lustrous = require('lustrous')
local smartmenu = require('smartmenu')
local rulez = require('rulez')

-- Map useful functions
calc = utility.calc
money = currencies.recalc
conv = utility.conversion

-- Autorun programs
local autorunApps = {
}

local tmuxSessionName = 'asshai'
local runOnceApps = {
   'lxpolkit',
   'xrdb -merge ~/.Xresources',
   'pulseaudio --start',
   'redshift -l 60.8:10.7 -m vidmode -g 0.8 -t 6500:5000',
   'systemctl --user restart mopidy',
   'tmux has-session -t ' .. tmuxSessionName .. ' || tmux new -d -s ' .. tmuxSessionName,
   'termite -e "zsh -c tmux attach -t ' .. tmuxSessionName .. '"',
}

utility.autorun(autorunApps, runOnceApps)

lustrous.init(private.user.loc)
utility.load_theme('devotion')

-- Configure screens
vista.setup {
   { rule = { name = "HDMI1" },
     properties = { secondary = true,
                    wallpaper = beautiful.wallpapers[2]} },
   { rule = { name = "eDP1" },
     properties = { primary = true, wallpaper = beautiful.wallpapers[1]} },
   { rule = { ratio = "1.25-" },
     properties = { wallpaper = beautiful.wallpapers[2],
		    statusbar = { position = "top", width = vista.scale(38),
				  unitybar_thin_mode = true } } },
   { rule = { },
     properties = { 
		    statusbar = { position = "right", width = vista.scale(58) }
     }
   }
}

-- Wallpaper
for s = 1, screen.count() do
   gears.wallpaper.maximized(vista[s].wallpaper, s, true)
end

   
-- Default system software
software = { terminal = "termite",
             terminal_cmd = "termite -e ",
             editor = "emacsclient",
             editor_cmd = "emacsclient -n -c ",
             browser = "google-chrome-stable --force-device-scale-factor=1 ",
             browser_cmd = "google-chrome-stable --force-device-scale-factor=1 "
}

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
   awful.layout.suit.floating, 	        -- 1
   awful.layout.suit.tile, 		-- 2
   awful.layout.suit.tile.bottom,	-- 3
   awful.layout.suit.max.fullscreen,
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
                          {  t   ,   t  ,   f  ,   f  ,   f  ,   f  ,   f  ,   f })
   end
end
-- }}}

-- Statusbar
for s = 1, screen.count() do
   statusbar.create(s, vista[s].statusbar)
end

-- Configure menubar
menubar.cache_entries = true
menubar.utils.terminal = software.terminal
menubar.app_folders = { "/usr/share/applications/",
			awful.util.getdir("config") .. "/scripts/" }
menubar.show_categories = false

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
                                               local t = utility.slurp(f, "*line")
					       os.execute("echo " .. t .. " | xclip")
                                               naughty.notify { title = "Image uploaded",
                                                                text = t}
		       end )
                       naughty.destroy(notif)
   end }
end

-- {{{ Key bindings
globalkeys = utility.keymap (
   "M-Left", function() utility.view_non_empty(-1) end ,
   "M-Right", function() utility.view_non_empty(1) end,
   "M-Tab", awful.tag.history.restore,
   "M-Up", function() awful.client.focus.byidx(1) utility.refocus() end,
   "M-Down", function() awful.client.focus.byidx(-1) utility.refocus() end,   
   "M-j", function() awful.client.focus.byidx(1) utility.refocus() end,
   "M-k", function() awful.client.focus.byidx(-1) utility.refocus() end,
   "M-i", function() vista.jump_cursor() end,
   "M-Tab", function() awful.client.focus.history.previous() utility.refocus() end,
   "M-C-n", awful.client.restore,
   -- Application launching
   "M-e", function() awful.util.spawn(software.editor_cmd) end,
   "M-w", function() awful.util.spawn(software.browser) end,
--   "M-q", function() utility.spawn_in_terminal("emacsclient --eval '(make-capture-frame)'") end,
   "XF86Launch1", function() utility.spawn_in_terminal("ncmpcpp") end,
   "Scroll_Lock", smartmenu.show,
   "XF86LaunchB", smartmenu.show,
   "M-p", function() menubar.show() end,
   "M-=", dict.lookup_word,
   "Print", function() awful.util.spawn("snap " .. os.date("%Y%m%d_%H%M%S")) end,
   "M-Return", function ()
      quake.toggle({ terminal = software.terminal_,
                     name = "QuakeTermite",
		     argname = "--name %s",
                     height = 0.25,
                     skip_taskbar = true,
                     ontop = true })
               end,
   "M-r", function ()
      local promptbox = statusbar[mouse.screen].widgets.prompt
      awful.prompt.run({ prompt = promptbox.prompt },
         promptbox.widget,
         function (...)
            local result = awful.util.spawn(...)
            if type(result) == "string" then
               promptbox.widget:set_text(result)
            end
         end,
         awful.completion.shell,
         awful.util.getdir("cache") .. "/history")
          end,
   "M-x", function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
         statusbar[mouse.screen].widgets.prompt.widget,
         awful.util.eval, nil,
         awful.util.getdir("cache") .. "/history_eval")
          end,
   -- Miscellaneous
   "XF86ScreenSaver", cmd(userdir .. "/scripts/screenlock"),
   "XF86MonBrightnessDown", cmd("xbacklight -" .. rc.xbacklight_step),
   "XF86MonBrightnessUp", cmd("xbacklight +" .. rc.xbacklight_step),
   "XF86AudioLowerVolume", function() statusbar[mouse.screen].widgets.vol:dec() end,
   "XF86AudioRaiseVolume", function() statusbar[mouse.screen].widgets.vol:inc() end,
   "XF86AudioMute", function() statusbar[mouse.screen].widgets.vol:mute() end,
   rc.keys.lock, cmd("xscreensaver-command -lock"),
   "M-l", minitray.toggle,
   "M-space", function()
      awful.layout.inc(layouts, 1)
      naughty.notify { title = "Layout changed", timeout = 2,
                       text = "Current layout: " .. awful.layout.get(mouse.screen).name }
              end,
   "M-b", function()
      statusbar[mouse.screen].wibox.visible = not statusbar[mouse.screen].wibox.visible
      
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
	  end,
   "M-S-q", awesome.quit,
   "M-S-r", function() awful.util.eval(awful.util.escape(awful.util.restart())) end
)   
   
clientkeys = utility.keymap(
   "M-f", function (c) c.fullscreen = not c.fullscreen end,
   "M-S-c", function (c) c:kill() end,
   "M-C-space", awful.client.floating.toggle,
   "M-o", function(c) vista.movetoscreen(c, nil, true) end,
   "M-S-o", vista.movetoscreen,
   "M-q", rulez.remember,
   "M-t", function (c) c.ontop = not c.ontop end,
   "M-n", function (c) c.minimized = true end,
   "M-m", function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical   = not c.maximized_vertical
          end
)

-- Compute the maximum number of digit we need, limited to 9
local keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
for i = 1, keynumber do
   globalkeys = utility.keymap(
      globalkeys,
      "M-#" .. i + 9, function ()
         local screen = mouse.screen
         if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
         end
                      end,
      "M-C-#" .. i + 9, function ()
         local screen = mouse.screen
         if tags[screen][i] then
            awful.tag.viewtoggle(tags[screen][i])
         end
                        end,
      "M-S-#" .. i + 9, function ()
         if client.focus and tags[client.focus.screen][i] then
            awful.client.movetotag(tags[client.focus.screen][i])
         end
                        end
   )
end

clientbuttons = utility.keymap(
   "LMB", function (c) client.focus = c; c:raise() end,
   "M-LMB", awful.mouse.client.move,
   "M-RMB", awful.mouse.client.resize)

statusbar[1].widgets.mpd:append_global_keys()
root.keys(globalkeys)

-- {{{ Rules
rulez.init({ { rule = { },
	       properties = {
		  border_width = beautiful.border_width,
		  border_color = beautiful.border_normal,
		  size_hints_honor = false,
		  focus = true,
		  keys = clientkeys,
		  buttons = clientbuttons
	       }
	     }
})

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
