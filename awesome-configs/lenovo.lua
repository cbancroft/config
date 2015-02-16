local awful = require('awful')
local utility = require('utility')

local lenovo = { touchpad = {},
                   power = {} }

function lenovo.touchpad.enable(value)
   local value = value and 0 or 1
   awful.util.spawn("synclient TouchpadOff=" .. value)
end

function lenovo.touchpad.toggle()
   local _, _, state = string.find(utility.pslurp("synclient -l | grep TouchpadOff",
                                            "*line"), ".*(%d)$")
   state = (state == "0")
   lenovo.touchpad.enable(not state)
end

function lenovo.power.screenlock()
   os.execute(userdir .. "/scripts/screenlock")
end

return lenovo
