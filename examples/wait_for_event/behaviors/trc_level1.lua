-- /// Torocó example - Wait for event trigger ///
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

return toroco.trigger (input.gate_1, callback1)

