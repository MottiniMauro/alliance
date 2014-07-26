-- /// trc_sender ///

local sched = require 'lumen.sched'
local device = require 'toroco.device'

local M = {}

M.triggers = {}


-- /// Output events ///
-- Events emitted by the module.

M.events = {motor1_setvel = {}, motor2_setvel = {}}


-- /// Callback functions ///

local callback1 = function(event, v) 
	print (event, '=', v)
    sched.signal (M.events.motor1_setvel, 0, 0)
end

local callback2 = function(event, v) 
	print (event, '=', v)
    sched.signal (M.events.motor2_setvel, v)
end


-- /// Triggers ///

M.triggers.trigger1 = { callback = callback1 }

M.triggers.trigger2 = { callback = callback2 }

return M
