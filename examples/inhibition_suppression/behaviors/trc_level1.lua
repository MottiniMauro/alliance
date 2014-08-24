-- /// trc_level1 ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local handler1 = function (event, value)
	print (' ')
	print (event, '=', value)

    toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
end

return toroco.trigger (input.trigger1, handler1)

