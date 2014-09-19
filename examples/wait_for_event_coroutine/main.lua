-- /// Torocó example - wait_for_event with coroutines ///
-- main.lua

-- imports

local toroco = require 'toroco.init'
local device = toroco.device
local behavior = toroco.behavior


-- initialize beh1

toroco.load_behavior (behavior.beh1, 'behaviors/trc_beh1')
toroco.load_behavior (behavior.beh2, 'behaviors/trc_beh2')

toroco.set_inputs (behavior.beh1, {
    gate_1 = device.mice.leftbutton,
    gate_2 = device.mice.leftbutton
})

toroco.set_inhibitors (device.mice, {
    leftbutton = behavior.beh2.clickbutton
})

toroco.set_inputs (behavior.beh2, {
    reset = device.mice.rightbutton
})

toroco.set_inputs (device.trc_motor, {
    setvel2mtr = behavior.beh1.motor1_setvel
})

-- run toroco

toroco.run ()


