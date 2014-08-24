-- /// trc_level1 ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Functions ///

local handler1 = function (event, value)
	print (' ')
	print (event, '=', value)

    toroco.send_output {motor1_setvel = {1, 33}}
end

return toroco.trigger (input.trigger1, handler1)

