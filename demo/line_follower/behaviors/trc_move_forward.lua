-- /// trc_move_forward ///

local toroco = require 'toroco.toroco'

-- /// Functions ///

local coroutine = function ()

    print ('move forward')
    toroco.set_output {motors_setvel = {100, 100}}
end

return coroutine



