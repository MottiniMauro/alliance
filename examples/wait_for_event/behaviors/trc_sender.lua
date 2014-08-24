-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Functions ///

-- send output callback

local callback1 = function(event, v1)
	print (' ')
	print ('1st =', v1)

    local v2 = toroco.wait_for_input (input.gate_2)
	print ('2nd =', v2)

    toroco.send_output {motor1_setvel = {88, 0}}
end

-- inhibition callback

local callback2 = function(event, value)
    
    if value then
        print ('\ninhibition started')
        toroco.inhibit (toroco.device.mice.leftbutton, 2.5)
    else
        print ('inhibition released')
        toroco.release_inhibition (toroco.device.mice.leftbutton)
    end
end

return toroco.trigger (input.gate_1, callback1), toroco.trigger (input.reset, callback2)

