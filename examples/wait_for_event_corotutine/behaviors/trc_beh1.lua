-- /// trc_beh1 ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Callback functions ///

-- send output coroutine

local coroutine1 = function()
    while true do
        print ('\nloop')

        local v1 = toroco.wait_for_input (input.gate_1)
        print ('1st =', v1)

        local v2 = toroco.wait_for_input (input.gate_2)
        print ('2nd =', v2)

        toroco.send_output {motor1_setvel = {88, 0}}
    end
end

-- inhibition callback

local callback2 = function(event, value)
    
    if value then
        print ('inhibition started')
        toroco.inhibit (toroco.device.mice.leftbutton, 2.5)
    else
        print ('inhibition released')
        toroco.release_inhibition (toroco.device.mice.leftbutton)
    end
end

--[[
toroco.add_coroutine (coroutine1)
--]]

return {
    output_events = { motor1_setvel = {} }; 
    
    input_handlers = {
        reset = callback2;
    };
}
