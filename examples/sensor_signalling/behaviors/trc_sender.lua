-- /// trc_sender ///

local toroco = require 'toroco.toroco'

-- /// Handler functions ///

local handler_left = function(event, v) 
	print (event, '=', v)
    toroco.send_output {repeater_event = {'left', v}}
end

local handler_right = function(event, v) 
	print (event, '=', v)
    toroco.send_output {repeater_event = {'right', v}}
end

return {
    output_events = { repeater_event = {} }; 
    
    input_handlers = {
        trigger_left = handler_left;
        trigger_right = handler_right;
    } 
}
