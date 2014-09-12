-- /// trc_move_forward ///

local toroco = require 'toroco.toroco'
local sched = require 'lumen.sched'
local input = toroco.input

-- /// Functions ///

local coroutine = function ()

    print ('move forward')
    toroco.set_output {motors_setvel = {1, 100, 1, 100}}
end

return coroutine



