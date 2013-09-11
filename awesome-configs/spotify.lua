--[[
A spotify backend for the awesome music framework.

Since we have no signals from spotify, we need to poll every few seconds
--]]
local awful = require ("awful")

local setmetatable = setmetatable
local capi = { widget = widget,
               button = awful.button,
               escape = awful.util.escape,
               join = awful.util.table.join,
               tooltip = awful.tooltip,
               timer = timer,
               emit_signal = awesome.emit_signal,
               connect_signal = awesome.connect_signal }
local coroutine = coroutine
local print = print
local io = io
local string=string
local screen=screen
-- Mpd: provides Music Player Daemon information
module("spotify")

TMP_FILE     = '/tmp/vicious-spotify'
STATUS_CMD   = '/bin/bash -c "exec qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player PlaybackStatus  > ' .. TMP_FILE .. '"'
METADATA_CMD = '/bin/bash -c "exec qdbus org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.GetMetadata"'


local state
local dbus_commands
local reset = function()
   --print( "SPOTIFY: Reset" )
   state = {}
   dbus_commands = {}
   dbus_commands["pause"] = "org.mpris.MediaPlayer2.Player.Pause"
   dbus_commands["play"] = "org.mpris.MediaPlayer2..Player.PlayPause"
   dbus_commands["toggle"] = "org.mpris.MediaPlayer2.Player.PlayPause"
   dbus_commands["prev"] = "org.mpris.MediaPlayer2.Player.Prev"
   dbus_commands["next"] = "org.mpris.MediaPlayer2.Player.Next"
   setmetatable(state, {__index = function() return "N/A" end})
end
reset()
local set = function(key, value)
    state[key] = value
end

local cmd = function(command)
   local dbus_cmd = dbus_commands[command]
   if dbus_cmd then
      --print( "SPOTIFYCMD: " ..  '/bin/bash -c "exec qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 ' .. dbus_cmd .. '"' )
      local bla =      io.popen( '/bin/bash -c "exec qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 ' .. dbus_cmd .. '"')
      local res = bla:read("*l")
      bla:close()
      --print( "RESULTS: " .. res )
   end
end

    
local query_spotify_state = function( file )
   --print( "SPOTIFY: Query State" )
   local tmp = io.popen( '/bin/bash -c "exec /usr/bin/qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player PlaybackStatus"' )
   local state = tmp:read("*l")
   --print( "SPOTIFY: query_spotify_state :: state ==> " .. state )
   tmp:close()
   return state
end

local refresh_co = function()
   --print( "SPOTIFY: Refresh Coroutine" )

   -- Get Playing State
   local spotify_state = query_spotify_state( TMP_FILE )
   --print( "SPOTIFY: refresh_co::Setting state to " .. spotify_state )
   state["state"] = spotify_state

   -- Get song info
   local metadata = io.popen( METADATA_CMD )
   print( "Execing: " .. METADATA_CMD )
   for line in metadata:lines() do
      for k,v in string.gmatch( line, "xesam:(%w+):(.*)" ) do
	 --print( "SPOTIFY: Setting " .. k .. " = " .. v )
	 set( k, v )
      end
   end
   metadata:close()

   screen[1]:emit_signal("music::update")
   
end

-- Default watcher to return false
local watcher = nil
local timer = capi.timer({timeout = 2})

local refresh = function()
--    if not watcher or not coroutine.resume(watcher) then
--        watcher = coroutine.create(refresh_co)
   --    end
   refresh_co()
end
timer:connect_signal("timeout", refresh)

start = function()
    reset()
    timer:start()
    screen[1]:emit_signal("music::update")
end

stop = function()
    timer:stop()
    pause()
end


-- {{{ Actions

next = function()
   cmd("next")
   refresh()
end

prev = function()
   cmd("prev")
   refresh()
end

toggle = function()
   cmd("toggle")
   refresh()
end

play = function()
   cmd("unpause")
   refresh()
end

pause = function()
   cmd("pause")
   refresh()
end

remove = function()
    refresh()
end

get = function(item)
    return state[item]
end

isPlaying = function()
    return state["state"] == "Playing"
end
    
    
    
-- }}}
