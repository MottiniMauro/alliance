-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

-- initialize behaviors

toroco.load_behavior (behavior.receiver, 'behaviors/trc_receiver')

-- initialize inputs

toroco.set_inputs (behavior.receiver, {
    trigger1 = device.test_sensor.update
})

toroco.set_inputs (device.test_actuator, {
    send = behavior.receiver.pong
})
--]]

-- run toroco

toroco.run ()


