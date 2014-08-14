-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Callback functions ///

local callback1 = function(event, v1) 
	print ('left =', v1)

    local v2 = toroco.wait_for_input (input.gate_2)
	print ('right =', v2)

    if v1 == v2 then
        toroco.send_output {motor1_setvel = {88, 0}}
    else
        toroco.send_output {motor1_setvel = {0, 99}}
    end
end

return {
    output_events = { motor1_setvel = {} }; 
    
    input_handlers = {
        gate_1 = callback1;
    };
}
