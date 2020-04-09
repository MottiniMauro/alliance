-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local handler1 = function (event, x, y)

    print ('\nred follower: x =', x)
    
    if not x then
        print ('nothing')
        toroco.unset_output ()

    elseif x < -50 then
        print ('turn left ')
        toroco.set_output {motors_setvel = params.motors_lx}

    elseif x < -25 then
        print ('turn left ')
        toroco.set_output {motors_setvel = params.motors_l}

    elseif x > 50 then
        print ('turn right')
        toroco.set_output {motors_setvel = params.motors_rx}

    elseif x > 25 then
        print ('turn right')
        toroco.set_output {motors_setvel = params.motors_r}

    else
        print ('forward')
        toroco.set_output {motors_setvel = params.motors_f}
    end
end

return toroco.trigger (input.update, handler1)



