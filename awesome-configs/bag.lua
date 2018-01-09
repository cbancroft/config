local wibox = require("wibox")
local wlayout = require("wibox.layout")
local wcontainer = require("wibox.container")
local widget = require("wibox.widget")
local util = require("awful.util")
local bag = { mt = {} }

local DELTA_MAX = 100000

function bag:layout(context, all_width, all_height)
   local rows = {
      {
	 width = 0,
	 height = 0,
	 y = 0
      },
      width = 0,
      height = 0
   }

   local result = {}
   local function diff(a, b)
      return math.abs(a - b)
   end

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

   local function add_to_best_row( wdg, w, h )
      local res = {}
      local deltas = {}

      for i, row in ipairs(rows) do
	 if (row.width + w < all_width) and
	 (row.y + math.max(row.height, h) <= all_height) then
	    table.insert(res,i)
	    deltas[i] = diff( math.max(rows.width, row.width + w),
			      rows.height + ((h > row.height) and (h - row.height) or 0 ))
	 else
	    deltas[i] = DELTA_MAX
	 end
      end

      if (rows[#rows].y + rows[#rows].height + h <= all_height ) and
      (w < all_width) then
	 deltas[#rows+1] = diff(math.max(rows.width,w), rows.height + h)
	 table.insert(res, #rows+1)
      else
	 deltas[#rows+1] = DELTA_MAX
      end

      local best_delta, best_row = DELTA_MAX, nil

      for i, delta in ipairs(deltas) do
	 if delta < best_delta then
	    best_delta = delta
	    best_row = i
	 end
      end

      if best_row ~= nil then
	 if best_row > #rows then
	    table.insert(rows, { width = 0, height = 0, y = rows.height})
	 end
	 table.insert(rows[best_row], {widget = wdg, width = w, height = w})
	 recalc_curr_dim()
      end
   end

   print( "Drawing bag", self)

   for k, v in pairs(self.widgets) do
      print( "Fitting widget", v, all_width, all_height)
      local wdg_w, wdg_h = widget.base.fit_widget(self, context, v, all_width, all_height)
      add_to_best_row(v, wdg_w, wdg_h)
   end

   local y = (all_height - rows.height) / 2
   for i, row in ipairs(rows) do
      local x = (all_width - row.width) / 2
      for j, item in ipairs(row) do
	 table.insert( result, widget.base.place_widget_at(item.widget, x, y, item.width, item.height))
	 x = x + item.width
      end
      y = y + row.height
   end

   return result
end

function bag:add(w)
   widget.base.check_widget(w)
   table.insert(self.widgets, w)
   w:connect_signal("widget::updated", self._emit_updated)
   self._emit_updated()
end

function bag:fit(context, orig_width, orig_height)
   print( "FITTING BAG", orig_width, orig_height)
   return orig_width, orig_height
end

function bag:reset()
   for k, v in pairs(self.widgets) do
      v:disconnect_signal("widget::updated", self._emit_updated)
   end
   self.widgets = {}
   self.emit_signal("widget::updated")
end

function bag.new( m )
   local ret = widget.base.make_widget()

   util.table.crush(ret, bag)

   ret.widgets = {}
   ret._emit_updated = function()
      ret:emit_signal("widget::updated")
   end

   return ret
end

function bag.mt.__call(_, ...)
   return new(...)
end
return setmetatable(bag, bag.mt)
