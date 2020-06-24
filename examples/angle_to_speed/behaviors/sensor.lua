-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local sensor_handler = function(event, v)
	print ('value ' .. v )
	toroco.send_output {motor_move = {v}}
end


return toroco.trigger (input.trigger, sensor_handler)
