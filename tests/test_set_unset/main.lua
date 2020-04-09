-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


-- initialize behaviors

toroco.load_behavior (behavior.emit1, 'behaviors/emit', {motors_values = {1, 30, 1, 100}})
toroco.load_behavior (behavior.emit2, 'behaviors/emit', {motors_values = {1, 100, 1, 30}})
toroco.load_behavior (behavior.motor1, 'behaviors/print', {motor = 1})
toroco.load_behavior (behavior.motor2, 'behaviors/print', {motor = 2})

-- initialize inputs

toroco.set_inputs (behavior.emit1, {
    trigger = device.mice.leftbutton
})

toroco.set_inputs (behavior.emit2, {
    trigger = device.mice.rightbutton
})

toroco.set_inputs (behavior.motor1, {
    motors_setvel = {
        behavior.emit1.motors_setvel,
        behavior.emit2.motors_setvel
    }
})

toroco.set_inputs (behavior.motor2, {
    motors_setvel = behavior.emit1.motors_setvel
})


-- run toroco

toroco.run ()


