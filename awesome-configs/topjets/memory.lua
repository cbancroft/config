local wibox = require('wibox')
local iconic = require('iconic')
local scheduler = require('scheduler')

-- Module topjets.cpu
local memory = {}

local iconic_args = { preferred_size = "24x24", icon_types = { "/actions/" } }
local icons

function memory.new()
   icons = { iconic.lookup_icon("brasero-disc-00", iconic_args),
             iconic.lookup_icon("brasero-disc-20", iconic_args),
             iconic.lookup_icon("brasero-disc-40", iconic_args),
             iconic.lookup_icon("brasero-disc-60", iconic_args),
             iconic.lookup_icon("brasero-disc-80", iconic_args),
             iconic.lookup_icon("brasero-disc-100", iconic_args) }

   local _widget = wibox.widget.imagebox()
   scheduler.register_recurring("memory_update", 10,
                                function() memory.update(_widget) end)
   return _widget
end

local function get_usage_icon (usage_p)
   if usage_p > 100 then
      usage_p = 100
   end
   if usage_p < 0 then
      usage_p = 0
   end
   local idx = math.floor ( ( usage_p + 10 ) / 20 ) + 1
   return icons[idx]
end

function memory.update(w)
   local _mem = { buf = {} }

   -- Get MEM info
   for line in io.lines("/proc/meminfo") do
      for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
         if     k == "MemTotal"  then _mem.total = math.floor(v/1024)
         elseif k == "MemFree"   then _mem.buf.f = math.floor(v/1024)
         elseif k == "Buffers"   then _mem.buf.b = math.floor(v/1024)
         elseif k == "Cached"    then _mem.buf.c = math.floor(v/1024)
         end
      end
   end

   -- Calculate memory percentage
   _mem.free  = _mem.buf.f + _mem.buf.b + _mem.buf.c
   _mem.inuse = _mem.total - _mem.free
   _mem.usep  = math.floor(_mem.inuse / _mem.total * 100)

   w:set_image(get_usage_icon(_mem.usep))
end

return setmetatable(memory, { __call = function(_, ...) return memory.new(...) end})
