local wibox = require("wibox")
local wlayout = require("wibox.layout")
local wcontainer = require("wibox.container")
local widget_base = require("wibox.widget.base")

local layout = {}

function layout.margin(m)
   if m.margin ~= nil then
      return wcontainer.margin(m[1], m.margin, m.margin,
                            m.margin, m.margin)
   elseif m.margins ~= nil then
      return wcontainer.margin(m[1], unpack(m.margins))
   else
      return wcontainer.margin(m[1], m.margin_left or 0, m.margin_right or 0,
                            m.margin_top or 0, m.margin_bottom or 0)
   end
end

function layout.fixed(m)
   local m_linear
   if m.vertical then
      m_linear = wlayout.fixed.vertical()
   else
      m_linear = wlayout.fixed.horizontal()
   end
   for _, w in ipairs(m) do
      m_linear:add(w)
   end
   return m_linear
end

function layout.flex(m)
   local m_flex
   if m.vertical then
      m_flex = wlayout.flex.vertical()
   else
      m_flex = wlayout.flex.horizontal()
   end
   for _, w in ipairs(m) do
      m_flex:add(w)
   end
   return m_flex
end

function layout.align(m)
   local a_layout
   if m.vertical then
      a_layout = wlayout.align.vertical()
   else
      a_layout = wlayout.align.horizontal()
   end
      if m.start ~= nil then
	 a_layout.first = m.start
      end
      if m.middle ~= nil then
	 a_layout.second = m.middle
      end
      if m.finish ~= nil then
	 a_layout.third = m.finish
      end

   return a_layout
end

function layout.center(m)
   local w = m[1]
   if m.vertical then
      local v_center = wlayout.align.vertical()
      v_center.first = nil
      v_center.third = nil
      v_center.second = w
      w = v_center
   end
   if m.horizontal then
      local h_center = wlayout.align.horizontal()
      h_center.first = nil
      h_center.third = nil
      h_center.second = w
      w = h_center
   end
   return w
end

function layout.midpoint(m)
   return layout.center { m[1], horizontal = m.vertical,
                          vertical = not m.vertical }
end

function layout.exact(m)
   return wcontainer.constraint(m[1], 'exact', m.size or m.width,
                             m.size or m.height)
end

function layout.constrain(m)
   return wcontainer.constraint(m[1], m.strategy or 'max', m.size or m.width,
                             m.size or m.height)
end

function layout.single(m)
   return wcontainer.constraint(m[1])
end

function layout.background(m)
   local bg = wibox.widget.background()
   bg:set_widget(m[1])
   if m.image then
      bg:set_bgimage(m.image)
   end
   if m.color then
      bg:set_bg(m.color)
   end
   return bg
end

local bag = {}

function bag:layout(cr, all_width, all_height)
    local rows = { { width = 0, height = 0, y = 0 }, width = 0, height = 0 }
    local result = {}
    -- {{{ Calculate the absolute difference
    local function diff(a, b)
        return math.abs(a - b)
    end
    -- }}}

    -- {{{ Recalc current dimensions
    local function recalc_curr_dim()
        rows.width, rows.height = 0, 0
        for i, row in ipairs(rows) do
            row.width, row.height, row.y = 0, 0, rows.height
            for j, item in ipairs(row) do
                row.width = row.width + item.width
                row.height = math.max(row.height, item.height)
            end
            rows.width = math.max(rows.width, row.width)
            rows.height = rows.height + row.height
        end
    end
    -- }}}

    -- {{{ Add widget to best row
    local function add_to_best_row (widget, w, h)
        local res = {}
        local deltas = {}
        for i, row in ipairs(rows) do
            if (row.width + w < all_width) and
                (row.y + math.max(row.height, h) <= all_height) then
                table.insert(res, i)
                deltas[i] = diff(math.max(rows.width, row.width + w), rows.height + ((h > row.height) and (h - row.height) or 0))
            else
                deltas[i] = 100000
            end
        end
        if (rows[#rows].y + rows[#rows].height + h <= all_height) and
            (w < all_width) then
            deltas[#rows+1] = diff(math.max(rows.width, w), rows.height + h)
            table.insert(res, #rows + 1)
        else
            deltas[#rows+1] = 100000
        end

        local best_delta, best_row = 100000, nil
        for i, delta in ipairs(deltas) do
            if delta < best_delta then
                best_delta = delta
                best_row = i
            end
        end

        if best_row ~= nil then
            if best_row > #rows then
                table.insert(rows, { width = 0, height = 0, y = rows.height })
            end
            table.insert(rows[best_row], { widget = widget, width = w, height = h })
            recalc_curr_dim()
        end
    end
    -- }}}

    for k, v in pairs(self.widgets) do
        local wdg_w, wdg_h = widget_base.fit_widget(self, cr, v, all_width, all_height)
        add_to_best_row(v, wdg_w, wdg_h)
    end

    local y = (all_height - rows.height) / 2
    for i, row in ipairs(rows) do
        local x = (all_width - row.width) / 2
        for j, item in ipairs(row) do
            table.insert( result, widget_base.place_widget_at(item.widget, x, y, item.width, item.height) )
            x = x + item.width
        end
        y = y + row.height
    end
    return result
end

function bag:add(widget)
    widget_base.check_widget(widget)
    table.insert(self.widgets, widget)
    widget:connect_signal("widget::layout_changed", self._emit_updated)
    widget:connect_signal("widget::redraw_needed", self._emit_updated)
    self._emit_updated()
end

function bag:fit(context, orig_width, orig_height)
    return orig_width, orig_height
end

function bag:reset()

    for k, v in pairs(self.widgets) do
       v:disconnect_signal("widget::layout_changed", self._emit_updated)
       v:disconnect_signal("widget::redraw_needed", self._emit_updated)
    end
    self.widgets = {}
    self:emit_signal("widget::layout_changed")
    self:emit_signal("widget::redraw_needed")
end

function layout.bag(m)
    local ret = widget_base.make_widget(nil, nil, {enable_properties = true})

    for k, v in pairs(bag) do
        if type(v) == "function" then
            rawset(ret, k, v)
        end
    end

    ret.widgets = {}
    ret._emit_updated = function()
       ret:emit_signal("widget::layout_changed")
       ret:emit_signal("widget::redraw_needed")
    end

    return ret
end

return layout
