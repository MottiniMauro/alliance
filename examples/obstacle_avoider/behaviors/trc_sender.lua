-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local handler_button = function(event, v)
	toroco.send_output {motor_stop = {}}
end


return toroco.trigger (input.trigger_button, handler_button)

