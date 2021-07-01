-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local input = toroco.input

local handler1 = function (event, camera_output)
    toroco.set_output {motor_wander = {'0', '-1'}}
end

return toroco.trigger (input.update, handler1)



