-- /// trc_receiver ///

local toroco = require 'toroco.toroco'

-- /// Callback functions ///

local handler1 = function (event, side, value)

    if value then
        if side == 'left' then
            toroco.send_output {motor1_setvel = {99, 0}}
        else
            toroco.send_output {motor1_setvel = {0, 99}}
        end
    end
end

return {
    output_events = { motor1_setvel = {} }; 
    
    input_handlers = {
        trigger1 = handler1;
    } 
}
