-- /// trc_turn_right ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Functions ///

local handler1 = function (event, value)

    -- black detected
    if value then
        print ('\nstart turning right')
        toroco.set_output {motors_setvel = {1, 100, 1, 30}}

    -- white detected
    else
        print ('\nstop turning right')
        toroco.unset_output {}
    end
end

return toroco.trigger (input.trigger_right, handler1)



