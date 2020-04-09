-- /// Torocó example - Sensor signalling ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


-- initialize behaviors

toroco.load_behavior (behavior.sender, 'behaviors/trc_sender')
toroco.load_behavior (behavior.receiver, 'behaviors/trc_receiver')

toroco.set_inputs (behavior.sender, {
    trigger_left = device.mice.leftbutton,
    trigger_right = device.mice.rightbutton
})

toroco.set_inputs (behavior.receiver, {
    trigger1 = behavior.sender.repeater_event
})

-- initialize devices

toroco.set_inputs (device.trc_motor, {
    setvel2mtr = behavior.receiver.motor1_setvel
})

-- run toroco

toroco.run ()


