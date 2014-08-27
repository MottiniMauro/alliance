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
        toroco.suppress (behavior.move_forward.motors_setvel, device.trc_motor, nil, {1, 30, 1, 100})

    -- white detected
    else
        print ('\nstop turning left')
        toroco.release_suppression (behavior.move_forward.motors_setvel, device.trc_motor)
    end
end

return toroco.trigger (input.trigger_left, handler1)



