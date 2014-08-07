-- /// trc_sender ///

local toroco = require 'toroco.toroco'

-- /// Callback functions ///

local callback_left = function(event, v) 
	print (event, '=', v)
    toroco.send_output {repeater_event = {'left', v}}
end

local callback_right = function(event, v) 
	print (event, '=', v)
    toroco.send_output {repeater_event = {'right', v}}
end

return {
    output_events = { repeater_event = {} }; 
    
    triggers = {
        trigger_left = { callback = callback_left };
        trigger_right = { callback = callback_right };
    } 
}
