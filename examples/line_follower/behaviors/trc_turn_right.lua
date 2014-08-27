-- /// trc_turn_right ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local behavior = toroco.behavior
local device = toroco.device

-- /// Functions ///

local handler1 = function (event, value)

    -- black detected
    if value then
        print ('\nstart turning right')
        toroco.suppress (behavior.move_forward.motors_setvel, device.trc_motor, nil, {1, 100, 1, 30})

    -- white detected
    else
        print ('\nstop turning right')
        toroco.release_suppression (behavior.move_forward.motors_setvel, device.trc_motor)
    end
end

return toroco.trigger (input.trigger_right, handler1)



