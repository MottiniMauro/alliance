-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


-- initialize behaviors

toroco.load_behavior (behavior.move_forward, 'behaviors/trc_move_forward')
toroco.load_behavior (behavior.turn_left, 'behaviors/trc_turn', {motors_values = {30, 100}})
toroco.load_behavior (behavior.turn_right, 'behaviors/trc_turn', {motors_values = {100, 30}})
toroco.load_behavior (behavior.red_follower, 'behaviors/red_follower')

-- initialize inputs
---[[
toroco.set_inputs (behavior.turn_left, {
    trigger_turn = device.mice.leftbutton
})

toroco.set_inputs (behavior.turn_right, {
    trigger_turn = device.mice.rightbutton
})

toroco.set_inputs (device.servo_motors, {
    setvel2mtr = {
        behavior.move_forward.motors_setvel,
        behavior.turn_left.motors_setvel,
        behavior.turn_right.motors_setvel
    }
})

toroco.set_inputs (behavior.red_follower, {
    update = device.camera.update
})
--]]

-- run toroco

toroco.run ()


