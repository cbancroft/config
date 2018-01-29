-----------------------------------------------------------------------------------------------------------------------
--                                              Autostart app list                                                   --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local autostart = {}

-- Application list function
--------------------------------------------------------------------------------
function autostart.run()
	-- LXDE 
  awful.spawn.with_shell("lxpolkit")

	-- utils
	-- awful.spawn.with_shell("killall compton; compton")
	awful.spawn.with_shell("start-pulseaudio-x11")
  awful.spawn.with_shell("devmon")

	-- apps
	-- awful.spawn.with_shell("sleep 0.5 && transmission-gtk -m")
  awful.spawn.with_shell("sleep 0.5 && devmon")
end

-- Read and commads from file and spawn them
--------------------------------------------------------------------------------
function autostart.run_from_file(file_)
	local f = io.open(file_)
	for line in f:lines() do
		if line:sub(1, 1) ~= "#" then awful.spawn.with_shell(line) end
	end
	f:close()
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return autostart
