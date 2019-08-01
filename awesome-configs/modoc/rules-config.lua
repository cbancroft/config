-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")
local beautiful = require("beautiful")
local redtitle = require("redflat.titlebar")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

rules.base_properties = {
    border_width     = beautiful.border_width,
    border_color     = beautiful.border_normal,
    focus            = awful.client.focus.filter,
    raise            = true,
    -- size_hints_honor = false,
    screen           = awful.screen.preferred,
    titlebars_enabled= false,
    placement        = awful.placement.no_overlap + awful.placement.no_offscreen
}

rules.floating_any = {
    class = {
	"Clipflap", "Run.py",
    },
    role = { "AlarmWindow", "pop-up", },
    type = { "dialog" }
}

rules.titlebar_exceptions = {
    class = { "Cavalcade", "Clipflap", "Steam", "VirtualBox", "vmplayer" }
}

rules.maximized = {
    class = { "Emacs" }
}

-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:init(args)

    local args = args or {}
    self.base_properties.keys = args.hotkeys.keys.client
    self.base_properties.buttons = args.hotkeys.mouse.client


    -- Build rules
    --------------------------------------------------------------------------------
    self.rules = {
	{
	    rule       = {},
	    properties = args.base_properties or self.base_properties
	},
	{
	    rule_any   = args.floating_any or self.floating_any,
	    properties = { floating = true }
	},
	{
	    rule = { class = "Emacs" },
	    properties = { tag = "Edit" }
	},
        {
	    rule = { class = "Mattermost" },
	    properties = { tag = "Chat" }
	},

	{
	    rule = { role = "browser" },
	    properties = { tag = "Web" }
	},
	{
	    rule = { class = "jetbrains-idea" },
	    properties = { tag = "Code"}
	},
	{
	    rule = { class = "franz" },
	    properties = { tag = "Free"}
	},
	{
	    rule = {
		class = "jetbrains-.*",
		instance = "sun-awt-X11-XWindowPeer",
		name = "win.*"
	    },
	    properties = {
		tag = "Code",
		floating = true,
		focus = true,
		focusable = false,
		ontop = true,
		placement = awful.placement.restore,
		buttons = {}
	    }
	},
	{
	    rule = { class = "Mail" },
	    properties = { tag = "Mail" }
	}
    }


    -- Set rules
    --------------------------------------------------------------------------------
    awful.rules.rules = rules.rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules
