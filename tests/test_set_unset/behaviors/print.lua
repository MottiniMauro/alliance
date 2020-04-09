-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local handler1 = function (event, ...)

    print ('\nMotor', params.motor, ...)
end

return toroco.trigger (input.motors_setvel, handler1)



