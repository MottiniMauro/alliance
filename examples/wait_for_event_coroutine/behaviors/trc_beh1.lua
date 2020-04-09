-- /// trc_beh1 ///

local toroco = require 'toroco'
local input = toroco.input

-- /// Functions ///

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

return coroutine1

