-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local handler1 = function (event, value)

    -- black detected
    if value then
        print ('\nstart turning')
        toroco.set_output {motors_setvel = params.motors_values}

    -- white detected
    else
        print ('\nstop turning')
        toroco.unset_output {}
    end
end

return toroco.trigger (input.trigger_turn, handler1)



