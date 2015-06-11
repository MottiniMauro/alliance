-- /// beh ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local handler1 = function (event, value)
    toroco.send_output {motors_setvel = {1, 33, 0, 99}}
end

return toroco.trigger (input.trigger1, handler1)

