-- /// trc_avoid ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local handler1 = function (event, value)

    if value > 0 then
        print ('Avoiding!')
        --toroco.set_output {motors_setvel = params.motors_lx}
    else
        print ('Avoiding stopped!')
        toroco.unset_output ()
    end
end

return toroco.trigger (input.update, handler1)



