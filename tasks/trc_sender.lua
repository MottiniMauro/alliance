-- /// Toroco_test ///

local toroco = require 'toroco'
local sched = require 'lumen.sched'

-- local variables
	
local M = {}

local triggers = {}
local devices = {}

local motor1_setvel, motor2_setvel = {}, {}

-- Callback functions

local callback1 = function(event, v) 
	print (event, '=', v)
    sched.signal (motor1_setvel, 0, 0)
end

local callback2 = function(event, v) 
	print (event, '=', v)
    sched.signal (motor2_setvel, 1, 50, 1, 50)
end

-- Triggers

triggers.trigger1 = {event = 'leftbutton', callback = callback1}

triggers.trigger2 = {event = 'rightbutton', callback = callback2}

-- Output events emitted by the module.

local output_events = {motor1_setvel = motor1_setvel, motor2_setvel = motor2_setvel}

-- Init function

M.init = function(conf)

	toroco.register_behavior(conf, triggers, output_events)
end

return M
