local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local distance_callback = function(event, v)
	print ('girando 5 sec')
	if v < 30 then
		toroco.send_output {izq_move = {200}, der_move = {-200}}
	else
		toroco.send_output {izq_move = {200}, der_move = {200}}
	end
end


return toroco.trigger (input.trigger_distance, distance_callback)

