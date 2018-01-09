local awful = require('awful')
local utility = require('utility')
local wibox = require('wibox')
local beautiful = require('beautiful')
local iconic = require('iconic')
local keymap = utility.keymap
local unitybar = require("unitybar")
local statusbar = { bars = {} }
local vista = require("vista")
--local kit = require("kit")
local function map(f, coll)
    for i, v in ipairs(coll) do coll[i] = f(v) end
    return coll
end

local function terminal_with(command)
    return function() utility.spawn_in_terminal(command) end
end

--- Creates a new status bar for a screen with the given options
-- @param s Screen object to attach this statusbar to
function statusbar.create(s, options)
    -- Setup the proper options
    options = options or { position = "right", width = 58 }

    local is_v = (options.position == "left") or 
    (options.position == "right")

    options.is_vertical = is_v
    options.tooltip_position = (options.position == "left" and "bottom_left") or
    (options.position == "top" and "top_right") or 
    "bottom_right"

--    topjets.set_tooltip_position(options.tooltip_position)

    -- Create the widget bar to hold the status bar
    local bar = {}
    bar.wibox = awful.wibar { 
        position = options.position, 
        screen = s,
        width = is_v and options.width or nil,
        height = not is_v and options.width or nil
    }

    statusbar.initialize(bar, s, options)

    local w = bar.widgets
    bar.wibox:setup {
        { 
            -- Left/Top Widgets
            {  
                -- "Start" Button
                {
                    w.menu_icon,
                    strategy = "min",
                    width = vista.scale(32),
                    height = vista.scale(32),
                    layout = wibox.container.constraint
                },
                layout = wibox.container.margin,
                margins = (options.width - vista.scale(32)) / 2
            },
            w.prompt,
            layout = is_v and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal
        },
        -- Middle Widget
        w.unitybar,
        { 
            -- Right Widgets
            layout = is_v and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
            {
--                w.weather,
--                w.net,
                layout = wibox.container.margin,
                bottom = vista.scale(5)
            },
            {
--                w.kbd,
--                w.cpu,
                layout = wibox.container.margin,
                bottom = vista.scale(5),
                top    = vista.scale(5)
            },
            {
--                w.vol,
--                w.mpd.widget,
                layout = wibox.container.margin,
                bottom = vista.scale(5),
                top    = vista.scale(5)
            },
            {
--                w.mem,
--                w.battery,
                layout = wibox.container.margin,
                bottom = vista.scale(5),
                top    = vista.scale(5)
            },
            {
                nil,
                w.time,
                nil,
                layout = wibox.layout.align.vertical
            }
        },
        layout = is_v and wibox.layout.align.vertical or wibox.layout.align.horizontal

    }

    statusbar.bars[s] = bar
    return bar.wibox
end

--- Initialize the statusbar for the given screen with the proper widgets
-- @param bar Widget bar holding all of the given widgets
-- @param s Screen this bar belongs to
-- @table options Options being passed to initialization
-- @tparam boolean options.is_vertical Is this statusbar oriented vertically?
function statusbar.initialize(bar, s, options)
    local is_vertical = options.is_vertical
    local widgets = {}

    -- Menu
--    widgets.menu_icon = smartmenu.build( iconic.lookup_icon("start-here-arch3",
--    { preferred_size = "128x128",
--    icon_types = { "/start-here/" }}))
    --[[ Clock
    widgets.time = topjets.clock(options.width)
    widgets.time:buttons(
    keymap("LMB", function() awful.util.spawn(software.browser_cmd ..
        "calendar.google.com", false) end,
        "MMB", function() topjets.clock.calendar.switch_month(0) end,
        "WHEELUP", function() topjets.clock.calendar.switch_month(-1) end,
        "WHEELDOWN", function() topjets.clock.calendar.switch_month(1) end))

        -- CPU widget
        widgets.cpu = topjets.cpu(is_vertical)
        topjets.processwatcher.register(widgets.cpu, options.tooltip_position)
        widgets.cpu:buttons(keymap("LMB", terminal_with("htop"),
        "RMB", topjets.processwatcher.toggle_kill_menu,
        "WHEELUP", function() topjets.processwatcher.switch_sorter(-1) end,
        "WHEELDOWN", function() topjets.processwatcher.switch_sorter(1) end))

        -- Memory widget
        widgets.mem = topjets.memory()

        -- Battery widget
        widgets.battery = topjets.battery()
        widgets.battery:buttons(keymap("LMB", terminal_with("sudo powertop")))

        -- Network widget
        widgets.net = topjets.network(is_vertical)
        widgets.net:buttons(keymap("LMB", terminal_with("sudo wifi-menu")))

        -- Weather widget
        widgets.weather = topjets.weather(is_vertical)
        widgets.weather:buttons(keymap("LMB", widgets.weather.update))

        -- Volume widget
        widgets.vol = topjets.volume()
        widgets.vol:buttons(
        keymap("LMB", function() widgets.vol:mute() end,
        "WHEELUP", function() widgets.vol:inc() end,
        "WHEELDOWN", function() widgets.vol:dec() end))

        -- Keyboard widget
        widgets.kbd = topjets.kbd()
    --]]
        -- MPD widget
        --if s.index > 1 then
            -- MPD widget is one for all screens.
        --    widgets.mpd = statusbar.bars[screen[1]].widgets.mpd
        --else
        --    local mpd = awesompd:create()
        --    awesompd.set_text = function(t) end
        --    mpd.widget_icon = iconic.lookup_icon("gmpc", { preferred_size = "24x24",
        --    icon_types = { "/apps/" }})
        --    mpd.path_to_icons = beautiful.icon_dir
        --    mpd.browser = software.browser
        --    mpd.mpd_config = userdir .. "/.mpdconf"
        --    mpd.radio_covers = {
        --        ["listen.42fm.ru"] = "/home/unlogic/awesome/themes/devotion/stream_covers/42fm.jpg",
        --    }
        --    mpd:register_buttons({ { "", awesompd.MOUSE_LEFT, mpd:command_playpause() },
        --    { "Control", awesompd.MOUSE_SCROLL_UP, mpd:command_prev_track() },
        --    { "Control", awesompd.MOUSE_SCROLL_DOWN, mpd:command_next_track() },
        --    { "", awesompd.MOUSE_SCROLL_UP, mpd:command_volume_up() },
        --    { "", awesompd.MOUSE_SCROLL_DOWN, mpd:command_volume_down() },
        --    { "", awesompd.MOUSE_RIGHT, mpd:command_show_menu() },
        --    { "", "XF86AudioPlay", mpd:command_playpause() },
        --    { "", "XF86AudioStop", mpd:command_stop() },
        --    { "", "XF86AudioPrev", mpd:command_prev_track() },
        --    { "", "XF86AudioNext", mpd:command_next_track() }})
        --  mpd:run()
        --    mpd:init_onscreen_widget({ x = vista.scale(20), y = -vista.scale(30), font = "helvetica " .. vista.scale(11), screen = vista.primary })
        --    widgets.mpd = mpd
        --end
        ---[[
        widgets.unitybar = unitybar( s, awful.widget.taglist.filter.all, nil,
        {
            width = options.width,
            vertical= is_vertical,
            thin = options.unitybar_thin_mode,
            fg_normal = "#888888",
            bg_urgent = "#ff000088" 
        })
        --]]

        widgets.prompt = awful.widget.prompt()

        bar.widgets = widgets
    end

    return setmetatable(statusbar, { __index = statusbar.bars })
