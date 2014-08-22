-- /// Torocó example - Inhibition and suppression ///
-- main.lua


local toroco = require 'toroco.toroco'
local input = toroco.input
local output = toroco.output
local device = toroco.device
local behavior = toroco.behavior


-- initialize behaviors

-- /// Method 1: use load_behavior.

---[[
toroco.load_behavior (behavior.level1, 'behaviors/trc_level1')
toroco.load_behavior (behavior.level2, 'behaviors/trc_level2')
--]]

-- /// Method 2: use add_behavior ///
--[[

toroco.add_behavior (
    behavior.level1,

    {
        toroco.trigger (input.trigger1, function (event, value)
	        print (' ')
	        print (event, '=', value)

            toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
        end)
    },

    {
        output.motor1_setvel,
        output.motor2_setvel
    }
)

toroco.add_behavior (
    behavior.level2,

    {
        toroco.trigger (input.trigger1, function (event, value) 
	        print (' ')

            if value then
                print ('inhibition started')        

                --toroco.inhibit (device.mice.leftbutton, 2.5)
                toroco.suppress (device.mice.leftbutton, behavior.level1, 2.5, {'suppressed!'})

            else
                print ('inhibition released')   

                --toroco.release_inhibition (device.mice.leftbutton)
                toroco.release_suppression (device.mice.leftbutton, behavior.level1)
            end
        end)
    },

    {
    }
)

--]]

-- initialize inputs

toroco.set_inputs (behavior.level1, {
    trigger1 = device.mice.leftbutton
})

toroco.set_inputs (behavior.level2, {
    trigger1 = device.mice.rightbutton
})

toroco.set_inputs (device.trc_motor, {
    setvel2mtr = behavior.level1.motor1_setvel
})

-- run toroco

toroco.run ()


