-- /// trc_line_follower ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Functions ///

local handler_left = function (event, value) 
	print (event .. '_left = ', value)
    toroco.send_output {motors_setvel = {1, 0}}
end


local handler_right = function (event, value) 
	print (event .. '_right = ', value)
    toroco.send_output {motors_setvel = {0, 1}}
end

return toroco.trigger (input.trigger_left, handler_left), toroco.trigger (input.trigger_right, handler_right)



