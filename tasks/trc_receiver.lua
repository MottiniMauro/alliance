-- /// Toroco_test ///

-- local variables

local M = {}

local triggers = {}
local devices = {}

-- Callback functions

local callback = function(event, ...) 
	print (event, '=', ...)
end

-- Triggers

triggers.trigger1 = {event = 'motor1_setvel', callback = callback}

triggers.trigger2 = {event = 'motor2_setvel', callback = callback}

-- Events emitted by the module.

local output_events = {}

-- Init function

M.init = function(conf)
	local toroco = require 'toroco'
    local sched = require 'lumen.sched'

	toroco.register_behavior(conf, triggers, output_events)
end

return M
