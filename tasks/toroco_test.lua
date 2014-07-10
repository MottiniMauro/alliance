local M = {}

local triggers = {}
local devices = {}

local callback = function(event, v) 
	print (event, '=', v)
end


triggers.trigger1 = {event = 'leftbutton', callback = callback}

triggers.trigger2 = {event = 'rightbutton', callback = callback}

local output_events = {setvel2mtr={}}

M.init = function(conf)
	local toroco = require 'toroco'
    local sched = require 'lumen.sched'

	toroco.register_behavior(conf, triggers, output_events)
	
	print ("hola")
end

return M
