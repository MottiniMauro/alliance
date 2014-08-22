-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local output = toroco.output

-- /// functions ///

local handler_left = function(event, v)
	print (' ')
	print (event, '=', v)
    toroco.send_output {repeater_event = {'left', v}}
end

local handler_right = function(event, v) 
	print (' ')
	print (event, '=', v)
    toroco.send_output {repeater_event = {'right', v}}
end

-- triggers

local trigger1 = toroco.trigger (input.trigger_left, handler_left)
local trigger2 = toroco.trigger (input.trigger_right, handler_right)

-- add behavior

toroco.add_behavior (
    {
        trigger1, trigger2
    },
    
    {
        output.repeater_event
    }
)
