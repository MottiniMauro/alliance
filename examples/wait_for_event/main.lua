-- /// Torocó example - wait_for_event with callbacks ///
-- main.lua


-- imports

local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


-- initialize beh1

toroco.load_behavior (behavior.beh1, 'behaviors/trc_sender')

toroco.set_inputs (behavior.beh1, {
    gate_1 = device.mice.leftbutton,
    gate_2 = device.mice.leftbutton,
    reset = device.mice.rightbutton
})

-- initialize devices

toroco.set_inputs (device.trc_motor, {
    setvel2mtr = behavior.beh1.motor1_setvel
})

-- run toroco

toroco.run ()


