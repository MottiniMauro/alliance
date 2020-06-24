local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local handler_button = function(event, v)
        toroco.send_output {motor_move = {200}}
end


return toroco.trigger (input.trigger_button, handler_button)

