---------------------------------------------------------------------------
-- Screen Management library
-- -A module for querying, managing and configuring screens
-- Based on vista by alexander-yakushev
---------------------------------------------------------------------------

-- Environment setup
local awful = require('awful')
local utility = require('utility')

-- Module for querying, managing and configuring screens.
local vista = { 
    primary = 1, 
    secondary = 1, 
    properties = {},
    actual_dpi = 125, 
    baseline_dpi = 125,
    xrandr = {} 
}

local function merge(src, dst)
    for k, v in pairs(src) do
        dst[k] = v
    end
end

local function screen_name(scr)
    local name
    for k, v in pairs(scr.outputs) do
        name = k
        break
    end
    return name
end

local function screen_idx(name)
    for i = 1, screen.count() do
        if screen_name(screen[i]) == name then
            return i
        end
    end
end

local function matches(s, rule)
    local scr = screen[s]
    local geom = scr.geometry
    local w, h = geom.width, geom.height
    local ratio = w / h
    for k, v in pairs(rule) do
        if k == "name" then
            local name = screen_name(scr)
            if name ~= v then
                return false
            end
        end
        if k == "ratio" then
            local ratio_exp, quant = string.match(tostring(v), "([%d%.]+)(.?)")
            ratio_exp = tonumber(ratio_exp)
            if (quant == "+" and ratio < ratio_exp) or
                (quant == "-" and ratio > ratio_exp) or
                (quant ==  "" and ratio ~= ratio_exp) then
                return false
            end
        end
    end
    return true
end

function vista.setup(rules)
    vista.xrand_info = vista.xrandr.info()
    for s = 1, screen.count() do
        vista.properties[s] = {}
    end
    for i = #rules, 1, -1 do
        for s = 1, screen.count() do
            if matches(s, rules[i].rule) then
                local p = rules[i].properties
                if p.primary then
                    vista.primary = s
                end
                if p.secondary then
                    vista.secondary = s
                end
                p.primary = nil
                p.secondary = nil
                merge(p, vista.properties[s])
            end
        end
    end
end

local function next_screen()
    return screen[awful.util.cycle(screen:count(), awful.screen.focused().index+1)]    
end

--- Jump cursor to the center of the screen. Default is next screen, cycling.
function vista.jump_cursor(s)
    local new_s = s or next_screen()
    local geom = new_s.geometry
    awful.screen.focus(new_s.index)
    mouse.coords { x = geom.x + (geom.width / 2),
                   y = geom.y + (geom.height / 2) }
end

--- Smart Move a client to a screen. Default is next screen, cycling. If
-- same_tag is true, move client to the same tag of the next screen, not the
-- currently active tag.
-- @param c The client to move.
-- @param s The screen number, default to current + 1.
function vista.movetoscreen(c, s, same_tag)
    c = c or client.focus

    local was_maximized = { h = false, v = false }
    if c.maximized_horizontal then
        c.maximized_horizontal = false
        was_maximized.h = true
    end
    if c.maximized_vertical then
        c.maximized_vertical = false
        was_maximized.v = true
    end

    if c then
        s = s or next_screen()
        print( "Screen: " .. s.index )
        if same_tag then
            local i = c.screen.selected_tag.index
            c:move_to_tag(s.tags[i])
            s.tags[i]:view_only()
        end
        c.screen = s
        vista.jump_cursor(s)
    end

    if was_maximized.h then
        c.maximized_horizontal = true
    end
    if was_maximized.v then
        c.maximized_vertical = true
    end
end

--- Extract current display information from a call to xrandr
--[[
--Example Output:
-- 
Screen 0: minimum 320 x 200, current 5760 x 2160, maximum 8192 x 8192
eDP-1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 344mm x 193mm
   1920x1080     60.00*+
   1400x1050     59.98
   1280x1024     60.02
   1280x960      60.00
   1024x768      60.04    60.00
   960x720       60.00
   928x696       60.05
   896x672       60.01
   800x600       60.00    60.32    56.25
   700x525       59.98
   640x512       60.02
   640x480       60.00    59.94
   512x384       60.00
   400x300       60.32    56.34
   320x240       60.05
HDMI-1 connected 3840x2160+1920+0 (normal left inverted right x axis y axis) 1152mm x 648mm
   1920x1080     60.00 +  50.00    59.94    30.00    25.00    24.00    29.97    23.98
   4096x2160     24.00    23.98
   3840x2160     30.00*   25.00    24.00    29.97    23.98
   1920x1080i    60.00    50.00    59.94
   1280x1024     60.02
   1280x960      60.00
   1360x768      59.80
   1280x720      60.00    60.00    50.00    59.94
   1024x768      60.00
   800x600       60.32
   720x576       50.00
   720x480       60.00    59.94
   640x480       60.00    59.94
--]]
function vista.xrandr.info()
    local result = { actual_dpi = vista.baseline_dpi }
    local f = io.popen('xrandr')
    local i, d_tbl, read_next_line = 1

    for l in f:lines() do
        if read_next_line then
            read_next_line = false
            local pixel_w, pixel_h = l:match("%s*(%d+)x(%d+)")
            d_tbl.width.px = tonumber(pixel_w)
            d_tbl.height.px = tonumber(pixel_h)
            d_tbl.ratio = d_tbl.width.px / d_tbl.height.px
            if d_tbl.width.mm then
                d_tbl.active = true
                if d_tbl.width.mm > 0 then
                    d_tbl.dpi = math.floor(d_tbl.width.px / d_tbl.width.mm * 25.4)
                else -- Probably a Xephyr output
                    d_tbl.dpi = vista.baseline_dpi
                end
            else
                d_tbl.active = false
                -- We have to guess the DPI by resolution. If >FHD then HiDPI.
                d_tbl.dpi = vista.baseline_dpi * (d_tbl.width.px > 1920 and 2 or 1)
            end
            if not result.main_dpi or result.main_dpi < d_tbl.dpi then
                -- Biggest DPI is the main dpi
                result.main_dpi = d_tbl.dpi
            end
            table.insert(result, d_tbl)
            i = i + 1
        end
        local display_name = l:match("([%w%d]+) connected")
        if display_name then
            read_next_line = true
            local curr_w, curr_h, mm_w, mm_h =
            l:match("[%w%d]+ connected (%d+)x(%d+)%+%d+%+%d+[^%d]+(%d+)mm x (%d+)mm")
            -- curr_ are dimensions set by xrandr (they account scale)
            d_tbl = { name = display_name,
            width = { mm = tonumber(mm_w), curr = tonumber(curr_w) },
            height = { mm = tonumber(mm_h), curr = tonumber(curr_h) } }
            if d_tbl.width.mm and d_tbl.width.mm > 0 then
                d_tbl.actual_dpi = math.floor(d_tbl.width.curr / d_tbl.width.mm * 25.4)
                if i == 1 then
                    -- Native screen actual DPI is the DPI of the whole system.
                    result.actual_dpi = d_tbl.actual_dpi
                    ---------------------------------------------------------------------------
                end
            end
        end
    end
    return result
end

--- Sets the display settings via xrandr
-- @param native_on Keep the native display on?
-- @param external_on Keep the external Display on?
-- @param position How to orient the two screens
function vista.xrandr.set(native_on, external_on, position)
    local info = vista.xrandr_info
    local cmd = "xrandr"

    local calc_sizes = function(disp, on)
        disp.on = on and "--auto" or "--off"
        disp.scale = (info.main_dpi / disp.dpi > 1.5) and 2 or 1
        disp.width.pan, disp.height.pan
        = disp.width.px * disp.scale, disp.height.px * disp.scale
        disp.shifts = { left = 0, top = 0 }
    end

    local conf = function(disp)
        cmd = cmd .. string.format(" --output %s %s --scale %dx%d --panning %dx%d+%d+%d",
        disp.name, disp.on, disp.scale, disp.scale,
        disp.width.pan, disp.height.pan,
        disp.shifts.left, disp.shifts.top)
    end

    -- Native
    local native_disp = info[1]
    calc_sizes(info[1], native_on)

    -- External
    if info[2] then
        calc_sizes(info[2], external_on)
    end

    -- Calculate shifts
    if position then -- No prep means one is off. Zero shifts.
        if position == "leftof" then
            info[1].shifts.left = info[2].width.pan
        elseif position == "rightof" then
            info[2].shifts.left = info[1].width.pan
        elseif position == "above" then
            info[1].shifts.top = info[2].height.pan
        elseif position == "below" then
            info[2].shifts.top = info[1].height.pan
        else
            log.e("Wrong position: " .. position, "vista.xrandr")
        end
    end

    conf(info[1])
    if info[2] then
        conf(info[2])
    end

    log.e("Executing command '" .. cmd .. "'", "vista.xrandr" )
    os.execute(cmd)
end

--- Build submenu for the main Awesome menu
function vista.xrandr.menu()
    local set = function(a,b,c) return function() vista.xrandr.set(a,b,c) end end
    local info = vista.xrandr.info()
    -- Only makes sense if we have more than one display
    if info[2] then
        return {
            { "&Only", {
                { "&Native", set(true, false) },
                { "E&xternal", set(false, true) } } 
            },
            { "&Both", {
                { "Ext &above native", set(true, true, "above") },
                { "Ext &below native", set(true, true, "below") },
                { "Ext &left of native", set(true, true, "leftof") },
                { "Ext &right of native", set(true, true, "rightof") } } 
            } 
        }
    end
end

function vista.scale(dimension, allow_float)
    local info = vista.xrandr_info
    local scaled = dimension * (info.actual_dpi / vista.baseline_dpi)
    if allow_float then
        return scaled
    else
        return math.floor(scaled)
    end
end

vista.xrandr_info = vista.xrandr.info()

return setmetatable(vista, { __index = vista.properties })
