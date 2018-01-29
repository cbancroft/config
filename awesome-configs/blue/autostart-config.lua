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
	-- utils
	awful.spawn.with_shell("compton")
	awful.spawn.with_shell("pulseaudio")
	awful.spawn.with_shell("nm-applet")
	awful.spawn.with_shell("sleep 0.5 && bash ~/Documents/scripts/ff-sync.sh")

	-- gnome environment
	awful.spawn.with_shell("/usr/lib/gnome-settings-daemon/gsd-xsettings")
	awful.spawn.with_shell("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

	-- keyboard layouts
	awful.spawn.with_shell("kbdd")
	awful.spawn.with_shell("sleep 1 && bash ~/Documents/scripts/kbdd-setup.sh")

	-- apps
	awful.spawn.with_shell("clipflap")
	awful.spawn.with_shell("sleep 0.5 && transmission-gtk -m")
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
