-- /// trc_move_forward ///

local toroco = require 'toroco.toroco'
local params = toroco.params

-- /// Functions ///

local coroutine = function ()

    print ('move forward')
    toroco.set_output {motors_setvel = params.motors_values}
end

return coroutine



