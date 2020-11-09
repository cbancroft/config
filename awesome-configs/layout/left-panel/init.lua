-------------------------------------------------------------------------------
-- layout/init.lua
--
-- Defines the layout of the WM
--
-- Forked from version by @mewantcookieee
-------------------------------------------------------------------------------


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi

local create_dashboard_widget = require("layout.left-panel.dashboard")
local create_actionbar_widget = require("layout.left-panel.action-bar")

--- Left panel object.
-- The left panel contains the start-bar, the dashboard and search panels.
-- @tparam table screen The screen this panel will be shown on
local create_left_panel = function(screen)
    local action_bar_width = dpi(45)
    local panel_content_width = dpi(300)

    --- wibox for the start bar.
    local panel =
        wibox {
        screen = screen,
        width = action_bar_width,
        type = "dock",
        height = screen.geometry.height,
        -- Start in the upper left corner of the screen
        x = screen.geometry.x,
        y = screen.geometry.y,
        ontop = true,
        bg = beautiful.background.hue_800,
        fg = beautiful.fg_normal
    }

    -- Reserve `action_bar-width` pixels
    panel:struts(
        {
            left = action_bar_width
        }
    )

    --- Wibox surface used to catch clicks and automatically close the dashboard
    local backdrop =
        wibox {
        ontop = true,
        screen = screen,
        bg = "#00000000",
        type = "utility",
        x = screen.geometry.x,
        y = screen.geometry.y,
        width = screen.geometry.width,
        height = screen.geometry.height
    }

    backdrop:buttons(
        awful.util.table.join(
            awful.button(
                {},
                1,
                function()
                    print("Backdrop clicked")
                    panel:toggle()
                end
            )
        )
    )

    --- Opens the dashboard panel
    -- @param should_run_rofi Should we run rofi when this opens
    function panel:openPanel(should_run_rofi)
        print("Opening dashboard panel")
        panel.width = action_bar_width + panel_content_width
        backdrop.visible = true

        -- TODO: Why is this in here ??
        self.visible = false
        self.visible = true

        -- Set the dashboard to be visible
        self:get_children_by_id("panel_content")[1].visible = true

        if should_run_rofi then
            self:run_rofi()
        end

        self:emit_signal("opened")
    end

    --- Closes the dashboard panel
    function panel:closePanel()

        -- Narrow the panel to just the action bar
        self.width = action_bar_width
        self:get_children_by_id("panel_content")[1].visible = false
        backdrop.visible = false
        self:emit_signal("closed")
    end

    -- Dashboard starts closed
    panel.opened = false

    function panel:run_rofi()
        _G.awesome.spawn(
            apps.default.rofi,
            false,
            false,
            false,
            false,
            function()
                panel:toggle()
            end
        )
    end

    -- Hide this panel when app dashboard is called.
    function panel:hideDashboard()
        self:closePanel()
    end

    --- Toggles the panel open or closed.
    -- @tparam boolean should_run_rofi Should rofi be run when opened
    function panel:toggle(should_run_rofi)
        self.opened = not self.opened
        if self.opened then
            self:openPanel(should_run_rofi)
        else
            self:closePanel()
        end
    end

    local dashboard_widget = create_dashboard_widget(screen, panel)
    local actionbar_widget = create_actionbar_widget(screen, panel, action_bar_width)
    
    panel:setup {
        -- Nothing in the first slot
        nil,
        -- Dashboard in the second. Defaults to invisible until the
        -- actionbar toggles it on
        {
            {
                dashboard_widget,
                layout = wibox.layout.stack
            },
            id = "panel_content",
            bg = beautiful.background.hue_800 .. "66", -- Background color of Dashboard
            widget = wibox.container.background,
            visible = false,
            forced_width = panel_content_width
        },
        -- Actionbar (start bar) in the third
        actionbar_widget,
        layout = wibox.layout.align.horizontal
    }

    return panel
end

return create_left_panel
