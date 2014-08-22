-- /// Torocó example - Suspend and resume behaviors ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


-- initialize behaviors

toroco.load_behavior (behavior.level1, 'behaviors/trc_level1')
toroco.load_behavior (behavior.level2, 'behaviors/trc_level2')

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


