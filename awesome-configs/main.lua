-- {{{ Requires
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Make sure a client always has focus
require("awful.autofocus")

-- Widget and Layout library
local wibox = require("wibox")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkey_popup = require("awful.hotkeys_popup").widget


-- Theme handling library
local beautiful = require('beautiful')

-- Utility
local utility = require("utility")

-- Logging library
local log = require("log")

local scheduler = require('scheduler')
local private = require('private')
local vista = require("vista")

local quake = require("quake")
local currencies = require("currencies")
local dict = require("dict")
local statusbar = require('statusbar')
local rulez = require('rulez')
local tyrannical = require('tyrannical')

-- }}}

local cmd = utility.cmd
userdir = utility.pslurp("echo $HOME", "*line")


-- Map useful functions
calc = utility.calc
money = currencies.recalc
conv = utility.conversion

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
                               -- Make sure we don't go into an endless error loop
                               if in_error then return end
                               in_error = true

                               naughty.notify({
                                       preset = naughty.config.presets.critical,
                                       title = "Oops, an error happened!",
                                       text = tostring(err)
                               })
                               in_error = false
    end)
end
-- }}}

-- {{{ Variable Definitions

-- tmux session to make sure starts
local tmuxSessionName = 'asshai'

-- Autorun programs
local startupApps = {
    "setxkbmap -layout 'us' -variant ',winkeys,winkeys' -option grp:menu_toggle -option compose:ralt -option terminate:ctrl_alt_bksp",
    'xrdb -merge ~/.Xresources',
}

-- Applications that are run once on startup
local daemons = {
    'lxpolkit',
    'pulseaudio --start',
    'redshift -l 60.8:10.7 -m vidmode -g 0.8 -t 6500:5000',
    'emacs --daemon',
    'devmon'
}

-- Default system software
software = {
    terminal =
        {
            bin = "termite",
            cmd = "termite -e ",
            name = "Termite"
        },
    editor =
        {
            bin = "emacsclient",
            cmd = "emacsclient -n -c ",
            name = "Emacs"
        },
    browser =
        {
            bin = "google-chrome-stable --force-device-scale-factor=1 ",
            cmd = "google-chrome-stable --force-device-scale-factor=1 ",
            name = "Chrome"
        }
}

awful.util.terminal = software.terminal.cmd

-- Default modkey.
local theme = "m0d0c"
local modkey = "Mod4"
local altkey = "Mod1"

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme)
beautiful.init(theme_path)

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.floating, -- 1
    awful.layout.suit.tile, -- 2
    awful.layout.suit.tile.left, -- 3
    awful.layout.suit.tile.bottom, -- 4
    awful.layout.suit.fair, -- 5
    awful.layout.suit.fair.horizontal, -- 6
    awful.layout.spiral, -- 7
    awful.layout.suit.spiral.dwindle, -- 8
    awful.layout.suit.max.fullscreen, -- 9
}

awful.layout.layouts = layouts
-- }}}

-- {{{ Miscellaneous Initialization
-- Execute any autorun applications
local function run_daemons( daemons )
    for _, cmd in ipairs(daemons) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end

--utility.autorun(autorunApps, runOnceApps)
run_daemons(daemons)

-- Configure menubar
menubar.cache_entries = true
menubar.utils.terminal = software.terminal.cmd
menubar.show_categories = false

-- {{{ Key bindings
function setup_key_bindings()
    return utility.keymap(

        -- Tag Group
        "M-Left", awful.tag.viewprev, { description = "Previous Non-Empty", group = "tag" },
        "M-Right", awful.tag.viewnext, { description = "Next Non-Empty", group = "tag" },
        "M-Tab", awful.tag.history.restore, { description = "Go Back", group = "tag" },

        -- Client Group
        "M-Up", function() awful.client.focus.byidx(1) utility.refocus() end, { description = "Focus next", group = "client" },
        "M-Down", function() awful.client.focus.byidx(-1) utility.refocus() end, { description = "Focus prev", group = "client" },
        "M-j", function() awful.client.focus.byidx(1) utility.refocus() end, { description = "Focus next", group = "client" },
        "M-k", function() awful.client.focus.byidx(-1) utility.refocus() end, { description = "Focus prev", group = "client" },

        -- Screen group
        --        "M-i", function() vista.jump_cursor() end, { description = "Jump to the next screen", group = "screen" },
        "M-i", function() awful.screen.focus_relative(1) end, {description = "Jump to the next screen", group = "screen" },
        "M-Tab", function() awful.client.focus.history.previous() utility.refocus() end,
        "M-C-n", awful.client.restore,

        -- Layout group
        "M-space", function()
            awful.layout.inc(layouts, 1)
            naughty.notify {
                title = "Layout changed",
                timeout = 2,
                text = "Current layout: " .. awful.layout.get(mouse.screen).name
            }
                   end, { description = "select next", group = "layout" },

        -- Awesome group
        "M-s", hotkey_popup.show_help, { description = "Show help", group = "awesome"},
        --TODO: Use freedesktop menus
--        "Scroll_Lock", smartmenu.show, { description = "Show main menu", group = "awesome" },
--        "XF86LaunchB", smartmenu.show, { description = "Show main menu", group = "awesome" },
        "M-=", dict.lookup_word, { description = "Lookup dictionary definition", group = "awesome" },
        "Print", function() awful.spawn("snap " .. os.date("%Y%m%d_%H%M%S")) end, { description = "Snap screenshot", group = "awesome" },
        "M-Return", function()
            quake.toggle({
                    terminal = software.terminal.bin,
                    name = "QuakeTermite",
                    argname = "--name %s",
                    height = 0.25,
                    skip_taskbar = true,
                    ontop = true
            })
                    end, { description = "Open Quake Terminal", group = "awesome" },

        "M-S-q", awesome.quit, { description = "Quit Awesome", group = "awesome" },
        "M-S-r", awesome.restart, { description = "Restart Awesome", group = "awesome" },

        "M-b", function()
            statusbar[mouse.screen].wibox.visible = not statusbar[mouse.screen].wibox.visible

            local tags = mouse.screen.tags
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
               end, { description = "Toggle Statusbar", group = "awesome" },

        -- Application launching
        "M-e", function() awful.spawn(software.editor.cmd) end, { description = "Launch editor (" .. software.editor.name .. ")", group = "launcher" },
        "M-w", function() awful.spawn(software.browser.cmd) end, { description = "Launch browser (" .. software.browser.name .. ")", group = "launcher" },
        "XF86Launch1", function() utility.spawn_in_terminal("ncmpcpp") end, { description = "Launch ncmpcpp", group = "launcher" },
        "M-p", function() menubar.show() end, { description = "Show the Menubar", group = "launcher" },
        "M-r", function() statusbar[awful.screen.focused()].widgets.prompt:run() end, { description = "run prompt", group = "launcher" },
        "M-x", function()
            awful.prompt.run({ prompt = "Run Lua code: " },
                statusbar[mouse.screen].widgets.prompt.widget,
                awful.util.eval, nil,
                awful.util.getdir("cache") .. "/history_eval")
               end, { description = "lua prompt", group = "launcher" },

        -- Miscellaneous
        "XF86MonBrightnessDown", cmd("xbacklight -" .. rc.xbacklight_step), { description = "Decrease backlight", group = "misc" },
        "XF86MonBrightnessUp", cmd("xbacklight +" .. rc.xbacklight_step), { description = "Increase backlight", group = "misc" },
        "XF86AudioLowerVolume", function() statusbar[mouse.screen].widgets.vol:dec() end, { description = "Lower Volume", group = "misc" },
        "XF86AudioRaiseVolume", function() statusbar[mouse.screen].widgets.vol:inc() end, { description = "Raise Volume", group = "misc" },
        "XF86AudioMute", function() statusbar[mouse.screen].widgets.vol:mute() end, { description = "Mute Volume", group = "misc" },
        rc.keys.lock, function() cmd("xscreensaver-command -lock") end, { description = "Lock Screen", group = "misc" })
end

globalkeys = setup_key_bindings()

clientkeys = utility.keymap(
    "M-f", function(c) c.fullscreen = not c.fullscreen end, { description = "toggle fullscreen", group = "client" },
    "M-S-c", function(c) c:kill() end, { description = "close", group = "client" },
    "M-C-space", awful.client.floating.toggle, { description = "Toggle Floating", group = "client" },
    "M-o", function(c) c:move_to_screen() end, { description = "Move to Screen (preserve tag)", group = "client" },
    "M-q", rulez.remember, { description = "Remember tag", group = "client" },
    "M-t", function(c) c.ontop = not c.ontop end, { description = "Toggle keep on top", group = "client" },
    "M-n", function(c) c.minimized = true end, { description = "minimize", group = "client" },
    "M-m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
           end, { description = "maximize", group = "client" })

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
                                       -- View tag only.
                                       awful.key({ modkey }, "#" .. i + 9,
                                           function()
                                               local screen = awful.screen.focused()
                                               local tag = screen.tags[i]
                                               if tag then
                                                   tag:view_only()
                                               end
                                           end,
                                           { description = "view tag #" .. i, group = "tag" }),
                                       -- Toggle tag.
                                       awful.key({ modkey, "Control" }, "#" .. i + 9,
                                           function()
                                               local screen = awful.screen.focused()
                                               local tag = screen.tags[i]
                                               if tag then
                                                   awful.tag.viewtoggle(tag)
                                               end
                                           end,
                                           { description = "toggle tag #" .. i, group = "tag" }),
                                       -- Move client to tag.
                                       awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                           function()
                                               if client.focus then
                                                   local tag = client.focus.screen.tags[i]
                                                   if tag then
                                                       client.focus:move_to_tag(tag)
                                                   end
                                               end
                                           end,
                                           { description = "move focused client to tag #" .. i, group = "tag" }),
                                       -- Toggle tag on focused client.
                                       awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                           function()
                                               if client.focus then
                                                   local tag = client.focus.screen.tags[i]
                                                   if tag then
                                                       client.focus:toggle_tag(tag)
                                                   end
                                               end
                                           end,
                                           { description = "toggle focused client on tag #" .. i, group = "tag" }))
end

clientbuttons = utility.keymap("LMB", function(c) client.focus = c; c:raise() end,
                               "M-LMB", awful.mouse.client.move,
                               "M-RMB", awful.mouse.client.resize)

-- statusbar[1].widgets.mpd:append_global_keys()
root.keys(globalkeys)

-- {{{ Rules
-- First, set some settings
dofile(awful.util.getdir("config") .. "/baseRule.lua")
-- {{{ Rules
awful.rules.rules = {
    {rule = {},
     properties = {
         border_width = beautiful.border_width,
         border_color = beautiful.border_normal,
         -- size_hints_honor = false,
         focus = true,
         keys = clientkeys,
         buttons = clientbuttons,
         screen = function(c)
             return awesome.startup and c.screen or
                 awful.screen.focused()
         end,
         placement = awful.placement.no_overlap + awful.placement.no_offscreen
    } },
    { rule = { class = "Conky" },
      properties = { border_width = 0,
                     border_color = beautiful.border_normal,} },
}
-- }}}

-- {{{ Screen setup
screen.connect_signal("property::geometry", function(s)
                          if beautiful.wallpaper then
                              local wallpaper = beautiful.wallpaper
                              if type(wallpaper) == "function" then
                                  wallpaper = wallpaper(s)
                              end
                              gears.wallpaper.maximized(wallpaper, s, true)
                          end
end)

awful.screen.connect_for_each_screen(function(s)
        -- Create a status bar for each screen
        local statusbar_opts = {
            position = "right",
            width = vista.scale(58)
        }
        statusbar.create(s, statusbar_opts)

        beautiful.at_screen_connect(s)
end)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
                          if awesome.startup and
                              not c.size_hints.user_position and
                          not c.size_hints.program_position then
                              awful.placement.no_overlap(c)
                              awful.placement.no_offscreen(c)
                          end
end)

client.connect_signal("request::titlebars", function(c)
                          -- Mouse interactions
                          local buttons = utility.keymap("LMB", function()
                                                             client.focus = c
                                                             c:raise()
                                                             awful.mouse.client.move(c)
                                                                end,
                                                         "RMB", function()
                                                             client.focus = c
                                                             c:raise()
                                                             awful.mouse.client.resize(c)
                          end)

                          awful.titlebar(c):setup {
                              {
                                  --Left
                                  awful.titlebar.widget.iconwidget(c),
                                  buttons = buttons,
                                  layout = wibox.layout.fixed.horizontal
                              },
                              {
                                  --Middle
                                  {
                                      --Title
                                      align = "center",
                                      widget = awful.titlebar.widget.titlewidget(c)
                                  },
                                  buttons = buttons,
                                  layout = wibox.layout.flex.horizontal
                              },
                              {
                                  --Right
                                  awful.titlebar.widget.floatingbutton(c),
                                  awful.titlebar.widget.maximizedbutton(c),
                                  awful.titlebar.widget.stickybutton(c),
                                  awful.titlebar.widget.ontopbutton(c),
                                  awful.titlebar.widget.closebutton(c),
                                  layout = wibox.layout.fixed.horizontal()
                              },
                              layout = wibox.layout.align.horizontal
                                                  }
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
                          local focused = client.focus
                          if focused
                              and focused.class == c.class
                              and focused.instance == "sun-awt-X11-XDialogPeer"
                              and c.instance == "sun-awt-X11-XFramePeer"
                          then
                              return
                          end


                          if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                          and awful.client.focus.filter(c) then
                              client.focus = c
                          end
end)

--[[ TODO: Address this
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
--]]

-- }}}
