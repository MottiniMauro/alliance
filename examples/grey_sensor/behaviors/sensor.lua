-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local sensor_handler = function(event, v)
	print ('value ' .. v )
	if v > 200 then
		toroco.send_output {motor_move = {200}}
	else
		toroco.send_output {motor_move = {0}}
	end
end


return toroco.trigger (input.trigger, sensor_handler)
