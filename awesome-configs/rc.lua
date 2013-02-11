
-- {{{ License
--
-- Awesome configuration, using awesome 3.5 on Arch GNU/Linux
--   * Charles B. <charlie.bancroft@gmail.com>

-- Parts borrow from anrxc's configuration:
--   * http://git.sysphere.org/awesome-configs
-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")

-- Wibox is no longer part of standard library
local wibox = require("wibox")

--Notification Library
local naughty = require("naughty")

-- User libraries
local vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

local scratch = require("scratch")

beautiful = require("beautiful")
local menubar = require("menubar")

local my_widgets = require("widgets") 


-- }}}

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
			  if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-- {{{ Variable definitions
local altkey = "Mod1"
local modkey = "Mod4"
local terminal = "urxvtc"
local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local scount = screen.count()
local editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
-- Beautiful theme
beautiful.init(home .. "/.config/awesome/zenburn.lua")

-- Window management layouts
local layouts = {
  awful.layout.suit.tile,        -- 1
  awful.layout.suit.tile.bottom, -- 2
  awful.layout.suit.fair,        -- 3
  awful.layout.suit.max,         -- 4
  awful.layout.suit.magnifier,   -- 5
  awful.layout.suit.floating     -- 6
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then 
   for s = 1, screen.count() do
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
   end
elseif beautiful.wallpaper_cmd then
    exec( beautiful.wallpaper_cmd )
end
-- }}}

-- {{{ Tags
tags = {
  names  = { "term", "emacs", "web", "mail", "im", 6, 7, "pdf", "media" },
  layout = { layouts[2], layouts[1], layouts[1], layouts[4], layouts[1],
             layouts[6], layouts[6], layouts[5], layouts[6]
}}

for s = 1, scount do
  tags[s] = awful.tag(tags.names, s, tags.layout)
  for i, t in ipairs(tags[s]) do
      awful.tag.setproperty(t, "mwfact", i==5 and 0.13  or  0.5)
      awful.tag.setproperty(t, "hide",  (i==6 or  i==7) and true)
  end
end
-- }}}

my_widgets.init_widgets()
-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separator
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)
-- }}}

-- {{{ Org-mode agenda
orgmodeicon = wibox.widget.imagebox()
orgmodeicon:set_image(beautiful.widget_mail)

-- Initialize widget
orgwidget = wibox.widget.textbox()
-- Configure widget
local orgmode = {
  files = { home.."/org/todo.org",
    home.."/org/work.org"
  },
  color = {
    past   = '<span color="'..beautiful.fg_urgent..'">',
    today  = '<span color="'..beautiful.fg_normal..'">',
    soon   = '<span color="'..beautiful.fg_widget..'">',
    future = '<span color="'..beautiful.fg_netup_widget..'">'
}} -- Register widget
vicious.register(orgwidget, vicious.widgets.org,
  orgmode.color.past..'$1</span>-'..orgmode.color.today .. '$2</span>-' ..
  orgmode.color.soon..'$3</span>-'..orgmode.color.future.. '$4</span>', 601,
  orgmode.files
) -- Register buttons
orgwidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec("emacsclient --eval '(org-agenda-list)'") end),
  awful.button({ }, 3, function () exec("emacsclient --eval '(make-capture-frame)'") end)
))
--}}}


-- {{{ System tray
-- }}}
-- }}}

-- {{{ Wibox initialisation
my_wibox     = {}
mypromptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
))

for s = 1, screen.count() do
    -- Create a promptbox
    mypromptbox[s] = awful.widget.prompt()
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)
    -- Create the wibox
    my_wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 12,
        bg = beautiful.bg_normal, position = "top",
        border_color = beautiful.border_focus,
        border_width = beautiful.border_width
    })
    
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add( taglist[s] )
    left_layout:add( layoutbox[s] )
    left_layout:add( mypromptbox[s] )
    
    local center_layout = wibox.layout.fixed.horizontal()

    local right_layout=wibox.layout.fixed.horizontal()
    right_layout:add( my_widgets.layout_widgets() )

    if s == 1 then right_layout:add( wibox.widget.systray()) end


    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(center_layout)
    layout:set_right(right_layout)

    my_wibox[s]:set_widget(layout)
    
end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
--
-- {{{ Global keys
globalkeys = awful.util.table.join(
    -- {{{ Applications
    awful.key({ modkey }, "e", function () exec("emacsclient -n -c") end),
    awful.key({ modkey }, "r", function () exec("rox", false) end),
    awful.key({ modkey }, "w", function () exec("chromium") end),
    awful.key({ altkey }, "F1",  function () exec("urxvtc") end),
    awful.key({ modkey }, "F1", function () scratch.drop("urxvt", "bottom") end),
    awful.key({ modkey }, "a", function () exec("urxvt -T Alpine -e alpine") end),
    awful.key({ modkey }, "g", function () sexec("GTK2_RC_FILES=~/.gtkrc-gajim gajim") end),
    awful.key({ modkey }, "q", function () exec("emacsclient --eval '(make-capture-frame)'") end),
    awful.key({ altkey }, "F12", function () exec("slimlock") end),
    -- }}}

    -- {{{ Multimedia keys
    awful.key({}, "#160", function () exec("slimlock") end),
    awful.key({}, "XF86AudioMute", function () 
		 exec("/usr/bin/mute_toggle") 
		 vicious.force({volwidget})
				   end),
    awful.key({}, "XF86AudioLowerVolume", function () 
		 exec("/usr/bin/vol_down", false) 
		 vicious.force({volwidget})
					  end),
    awful.key({}, "XF86AudioRaiseVolume", function () 
		 exec("/usr/bin/vol_up", false) 
		 vicious.force({volwidget})
					  end),

    awful.key({}, "#232", function () exec("plight.py -s") end),
    awful.key({}, "#233", function () exec("plight.py -s") end),
    awful.key({}, "#244", function () exec("sudo /usr/sbin/pm-hibernate") end),
    awful.key({}, "#150", function () exec("sudo /usr/sbin/pm-suspend")   end),
    awful.key({}, "#225", function () exec("pypres.py") end),
    awful.key({}, "#157", function () if boosk then osk()
        else boosk, osk = pcall(require, "osk") end
    end),
    -- }}}

    -- {{{ Prompt menus
    awful.key({ altkey }, "F2", function ()
        --awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
	--		 function (...) promptbox[mouse.screen]:set_markup(exec(unpack(arg), false)) end,
	  --     awful.completion.shell, awful.util.getdir("cache") .. "/history")
	  mypromptbox[mouse.screen]:run()
    end),
    awful.key({ altkey }, "F3", function ()
        awful.prompt.run({ prompt = "Dictionary: " }, mypromptbox[mouse.screen].widget,
            function (words)
                sexec("crodict "..words.." | ".."xmessage -timeout 10 -file -")
            end)
    end),
    awful.key({ altkey }, "F4", function ()
        awful.prompt.run({ prompt = "Web: " }, mypromptbox[mouse.screen].widget,
            function (command)
                sexec("chromium 'http://yubnub.org/parser/parse?command="..command.."'")
                awful.tag.viewonly(tags[1][3])
            end)
    end),
    awful.key({ altkey }, "F5", function ()
        awful.prompt.run({ prompt = "Lua: " }, mypromptbox[mouse.screen].widget,
        awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
    end),
    -- }}}

    -- {{{ Awesome controls
    awful.key({ modkey }, "b", function ()
        wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),
    awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, "Shift" }, "r", function ()
		 mypromptbox[mouse.screen]:set_markup(awful.util.escape(awful.util.restart()))
    end),
    -- }}}

    -- {{{ Tag browsing
    awful.key({ altkey }, "n",   awful.tag.viewnext),
    awful.key({ altkey }, "p",   awful.tag.viewprev),
    awful.key({ altkey }, "Tab", awful.tag.history.restore),
    -- }}}

    -- {{{ Layout manipulation
    awful.key({ modkey }, "l",          function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact( 0.05) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey },          "space", function () awful.layout.inc(layouts,  1) end),
    -- }}}

    -- {{{ Focus controls
    awful.key({ modkey }, "p", function () awful.screen.focus_relative(1) end),
    awful.key({ modkey }, "s", function () scratch.pad.toggle() end),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey }, "j", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ altkey }, "Escape", function ()
        awful.menu.menu_keys.down = { "Down", "Alt_L" }
        local cmenu = awful.menu.clients({width=230}, { keygrabber=true, coords={x=525, y=330} })
    end),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1)  end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(1)  end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey}, "XF86Forward", function () awful.screen.focus_relative(1)  end),
    awful.key({ modkey}, "XF86Back",  function () awful.screen.focus_relative(-1) end)
    -- }}}
)
-- }}}

-- {{{ Client manipulation
clientkeys = awful.util.table.join(
    awful.key({ modkey }, "c", function (c) c:kill() end),
    awful.key({ modkey }, "d", function (c) scratch.pad.set(c, 0.60, 0.60, true) end),
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey }, "o",     awful.client.movetoscreen),
    awful.key({ modkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
    awful.key({ modkey, "Control"},"r", function (c) c:redraw() end),
    awful.key({ modkey, "Shift" }, "0", function (c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift" }, "c", function (c) exec("kill -CONT " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "s", function (c) exec("kill -STOP " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "t", function (c) toggle_titlebar(c) end ),
    awful.key({ modkey, "Shift" }, "f", function (c) if awful.client.floating.get(c)
        then awful.client.floating.delete(c);    awful.titlebar(c,{size=0})
        else awful.client.floating.set(c, true); awful.titlebar(c):set_widget(awful.titlebar.widget.titlewidget(c)) end
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
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewonly(tags[screen][i]) end
        end),
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewtoggle(tags[screen][i]) end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end))
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Chromium",  instance = "chromium" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Emacs",    instance = "emacs" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Emacs",    instance = "_Remember_" },
      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { class = "Xmessage", instance = "xmessage" },
      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { name  = "Alpine" },      properties = { tag = tags[1][4]} },
    { rule = { class = "Gajim.py" },    properties = { tag = tags[1][5]} },
    { rule = { class = "Akregator" },   properties = { tag = tags[1][8]} },
    { rule = { class = "Ark" },         properties = { floating = true } },
    { rule = { class = "Geeqie" },      properties = { floating = true } },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Pinentry.*" },  properties = { floating = true } },
}
-- }}}


-- {{{ Signals
--
-- {{{ Manage signal handler
client.connect_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating then
		toggle_titlebar(c)
    end

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        --awful.client.setslave(c)

        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.connect_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Notifications
naughty.config.timeout          = 10
naughty.config.presets.normal.screen           = 1
naughty.config.presets.normal.position         = "top_right"
naughty.config.presets.normal.margin           = 4
naughty.config.presets.normal.gap              = 1
naughty.config.presets.normal.ontop            = true
naughty.config.presets.normal.icon             = nil
naughty.config.presets.normal.icon_size        = 16
naughty.config.presets.normal.border_width     = 1
naughty.config.presets.normal.hover_timeout    = nil
naughty.config.presets.normal.bg               = '#111111'
naughty.config.presets.normal.border_color     = '#333333'
naughty.config.defaults.font                     = "Monaco 12"
naughty.config.presets.critical.bg = '#991000cc'

-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}
toggle_titlebar = function( c )
	if   c.titlebar then awful.titlebar(c, {size=0})
	else awful.titlebar(c, {modkey = modkey}):set_widget(awful.titlebar.widget.titlewidget(c)) end
end
