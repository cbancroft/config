local setmetatable = setmetatable
local io = require("io")
local getenv = os.getenv
local awesome = awesome
local screen = screen


local print = print
module("pianobar")

config_home = getenv("XDG_CONFIG_HOME") or "~/.config"
ctl_path = config_home .. "/pianobar/ctl"

local cmd = function(command)
    if io.type(ctl) ~= "file" then
        ctl = io.open(ctl_path, "a+")
    end
    ctl:write(command)
    ctl:flush()
    fireUpdate()
end



local state
local playing
local reset = function()
    state = {}
    playing = false;
    setmetatable(state, {__index = function() return "N/A" end})
end
reset()


start = function()
    reset()
    fireUpdate()
end

stop = function() end


get = function(key)
    return state[key]
end

set = function(key, value)
    state[key] = value
end

setPlaying = function(is_playing)
    playing = is_playing
    if is_playing then
        state["state"] = "playing"
    else
        state["state"] = "paused"
    end
end

fireUpdate = function()
   screen[1]:emit_signal("music::update")
end

-- {{{ Actions
    
next = function()
    cmd("n")
end

toggle = function()
    cmd("p")
end

play = function()
    if not playing then
        cmd("p")
    end
end

pause = function()
    if playing then
        cmd("p")
    end
end

ban = function()
    cmd("-")
end

love = function()
    cmd("+")
end

tired = function()
    cmd("t")
end

remove = ban
prev = love

isPlaying = function()
    return playing
end

-- }}}
