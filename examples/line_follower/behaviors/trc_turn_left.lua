-- /// trc_turn_left ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local behavior = toroco.behavior
local device = toroco.device

-- /// Functions ///

local handler1 = function (event, value)

    -- black detected
    if value then
        print ('\nstart turning left')
        toroco.set_output {motors_setvel = {1, 30, 1, 100}}

    -- white detected
    else
        print ('\nstop turning left')
        toroco.unset_output {}
    end
end

return toroco.trigger (input.trigger_left, handler1)



