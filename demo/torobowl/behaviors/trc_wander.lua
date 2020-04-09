-- /// trc_move_forward ///

local toroco = require 'toroco.toroco'
local sched  = require 'lumen.sched'
local params = toroco.params

-- /// Functions ///

-- steering has a value between -16 (left) and +16 (right)

local steering = 0

math.randomseed (os.time())

local coroutine = function ()

    print ('move forward')
    while true do

        -- randomize steering

        steering = math.random (-3, 3) * 6

        -- set motors speed

        if steering < 0 then
            toroco.set_output {motors_setvel = {steering, 30}}

        elseif steering > 0 then
            toroco.set_output {motors_setvel = {30, steering}}
        end

        print ('set steering', steering)

        -- turn a little

        sched.sleep (2)

        -- move forwrd a little

        toroco.set_output {motors_setvel = {20, 20}}

        sched.sleep (5)
    end
end

return coroutine

