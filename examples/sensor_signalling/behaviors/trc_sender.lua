-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

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

return toroco.trigger (input.trigger_left, handler_left), toroco.trigger (input.trigger_right, handler_right)

