-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

-- initialize behaviors

toroco.load_behavior (behavior.receiver, 'behaviors/trc_receiver')
toroco.load_behavior (behavior.sender, 'behaviors/trc_sender')

-- initialize inputs

toroco.set_inputs (behavior.receiver, {
    trigger1 = behavior.sender.ping
})

toroco.set_inputs (device.test_actuator, {
    send = behavior.receiver.pong
})
--]]

-- run toroco

toroco.run ()


