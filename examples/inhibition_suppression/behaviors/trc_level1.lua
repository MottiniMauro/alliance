-- /// trc_level1 ///

local toroco = require 'toroco.toroco'

-- /// Handler functions ///

local handler1 = function (event, v) 
	print (event, '=', v)
    toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
end

return {
    output_events = { motor1_setvel = {}, motor2_setvel = {} }; 
    
    input_handlers = {
        trigger1 = handler1;
    } 
}
