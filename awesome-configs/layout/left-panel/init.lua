local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local apps = require("configuration.apps")
local dpi = require("beautiful").xresources.apply_dpi

local create_dashboard_widget = require("layout.left-panel.dashboard")
local create_actionbar_widget = require("layout.left-panel.action-bar")

--- Left panel object.
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

    local openPanel = function(should_run_rofi)
        print("Opening dashboard panel")
        panel.width = action_bar_width + panel_content_width
        backdrop.visible = true
        panel.visible = false
        panel.visible = true
        panel:get_children_by_id("panel_content")[1].visible = true
        if should_run_rofi then
            panel:run_rofi()
        end
        panel:emit_signal("opened")
    end

    local closePanel = function()
        panel.width = action_bar_width
        panel:get_children_by_id("panel_content")[1].visible = false
        backdrop.visible = false
        panel:emit_signal("closed")
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
    function panel:HideDashboard()
        closePanel()
    end

    --- Toggles the panel open or closed.
    -- @tparam boolean should_run_rofi Should rofi be run when opened
    function panel:toggle(should_run_rofi)
        self.opened = not self.opened
        if self.opened then
            openPanel(should_run_rofi)
        else
            closePanel()
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
