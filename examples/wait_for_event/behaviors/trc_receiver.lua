-- /// trc_receiver ///

local toroco = require 'toroco.toroco'

-- /// Callback functions ///

local callback1 = function (event, value)

    if value then
        toroco.send_output {motor1_setvel = {99, 0}}
    else
        toroco.send_output {motor1_setvel = {0, 99}}
    end
end

return {
    output_events = { motor1_setvel = {} }; 
    
    input_handlers = {
        trigger1 = callback1;
    } 
}
