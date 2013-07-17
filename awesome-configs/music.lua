--[[
A Music framework widget.

Backends must provide:
    play()  - Play the current song.
    pause() - Pause the current song.
    toggle()- Toggle the play status of the current song.
    next()  - Skip to the next song (if possible).
    prev()  - Go back to the previous song (if possible).
    remove()- Remove the current song from the playlist (ban/rate low/delete
              etc.).

    start() - Called when the backend is started.
    stop()  - Called when the backend is stopped.

    get(key)- Takes a key (string) and returns metadata about the current song.
              Keys must be lower case and title, author, album, and state are
              required.

Backends must emit music::upsate when state changes.

Licenced under the WTFPL
--]]
local wibox = require("wibox")
local awful = require("awful")
local mpd = require("mpd")
local spotify = require("spotify")
local pianobar = require("pianobar")
local type = type
local setmetatable = setmetatable
local pairs = pairs
local table = table
local mpd = require("mpd")
local pianobar = require("pianobar")
local spotify = require("spotify")
local naughty = require("naughty")
local capi = { widget = wibox.widget,
               button = awful.button,
               escape = awful.util.escape,
               join = awful.util.table.join,
               menu = awful.menu,
               tooltip = awful.tooltip,
               timer = timer,
               emit_signal = awesome.emit_signal,
               connect_signal = awesome.connect_signal }
local coroutine = coroutine
local awesome = awesome
local screen = screen

-- Mpd: provides Music Player Daemon information
module("music")


BACKENDS = {
   ["mpd"] = mpd,
   ["pianobar"] = pianobar,
   ["spotify"] = spotify
}
DEFAULT_BACKEND = mpd
local backend = nil

setBackend = function(b)
    if backend ~= nil then
        backend.stop()
    end
    backend = b
    backend.start()
end

setBackend(DEFAULT_BACKEND)

widget = function(widget_template, tooltip_template, icon)
    local w = {
        icon = icon,
        widget_template = widget_template,
        tooltip_template = tooltip_template,
        widget = wibox.layout.fixed.horizontal(),
	textbox = capi.widget.textbox(),
	current_icon = capi.widget.imagebox()
    }
    w.widget:add(w.current_icon)
    w.widget:add(w.textbox)
    -- Populate the backends menu.
    local menu_items = {}
    for n, b in pairs(BACKENDS) do
        table.insert(menu_items, {n, function() setBackend(b) end})
    end
    w.backend_menu = capi.menu{ items = menu_items }

    w.widget:buttons(capi.join(
        capi.button({ }, 1, function () toggle() end),
        capi.button({ }, 3, function () w.backend_menu:toggle() end)
    ))
    w.tooltip = capi.tooltip({
        objects = {w.widget},
        timeout = 0
    })

    local update = function()
        w.textbox:set_markup(format(w.widget_template) )
        w.tooltip:set_text(
            format(w.tooltip_template)
        )
        if w.icon then
            if isPlaying() then
                w.current_icon:set_image(w.icon.play)
            else
                w.current_icon:set_image(w.icon.pause)
            end
        end
    end
    
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Setting up music::update signal",
                     text = awesome.startup_errors })
    
    screen[1]:add_signal("music::update")
    screen[1]:connect_signal("music::update", update)
    update()
    return w.widget
end

format = function(template)
    if backend ~= nil then
        return template:gsub("{(%w+)}", backend.get):gsub("%&","&amp;")
    else
        return "Backend unset."
    end
end

isPlaying = function()
    if backend ~= nil then
        return backend.isPlaying()
    else
        return false
    end
end

next = function()
    if backend ~= nil then
        backend.next()
    end
end

prev = function()
    if backend ~= nil then
        backend.prev()
    end
end

toggle = function()
    if backend ~= nil then
        backend.toggle()
    end
end

play = function()
    if backend ~= nil then
        backend.play()
    end
end

pause = function()
    if backend ~= nil then
        backend.pause()
    end
end

remove = function()
    if backend ~= nil then
        backend.remove()
    end
end
    
-- }}}
