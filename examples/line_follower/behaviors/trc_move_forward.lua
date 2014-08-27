-- /// trc_move_forward ///

local toroco = require 'toroco.toroco'
local sched = require 'lumen.sched'
local input = toroco.input

-- /// Functions ///

local coroutine = function (event, value)

    while true do

        -- move forward
	    print ('move forward')
        toroco.send_output {motors_setvel = {1, 100, 1, 100}}

        -- wait a little
        sched.sleep (0.5)
    end
end

return coroutine



