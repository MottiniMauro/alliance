-- /// trc_line_follower ///

local sched = require 'lumen.sched'
local device = require 'toroco.device'

local M = {}

M.triggers = {}


-- /// Output events ///
-- Events emitted by the module.

M.output_events = {motors_setvel = {}}


-- /// Callback functions ///

local callback1 = function(event, v) 
	print (event .. '_left = ', v)
    sched.signal (M.output_events.motors_setvel, 1, 0)
end


local callback2 = function(event, v) 
	print (event .. '_right = ', v)
    sched.signal (M.output_events.motors_setvel, 0, 1)
end


-- /// Triggers ///

M.triggers.trigger1 = { callback = callback1 }

M.triggers.trigger2 = { callback = callback2 }

return M
