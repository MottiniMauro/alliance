-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

-- initialize behaviors

--toroco.load_behavior (behavior.move_forward, 'behaviors/trc_move_forward', {motors_values = {20, 20}})
toroco.load_behavior (behavior.turn_left, 'behaviors/trc_turn', {motors_values = {5, 20}})
toroco.load_behavior (behavior.turn_right, 'behaviors/trc_turn', {motors_values = {20, 5}})
toroco.load_behavior (behavior.red_follower, 'behaviors/red_follower',
    {motors_lx = {15, 50}, motors_l = {30, 50},
    motors_f = {50, 50},
    motors_r = {50, 30}, motors_rx = {50, 15}})
toroco.load_behavior (behavior.wander, 'behaviors/trc_wander')

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
        --behavior.move_forward.motors_setvel,
        behavior.wander.motors_setvel,
        behavior.turn_left.motors_setvel,
        behavior.turn_right.motors_setvel,
        behavior.red_follower.motors_setvel
    }
})

toroco.set_inputs (behavior.red_follower, {
    update = device.camera.update
})
--]]

-- run toroco

toroco.run ()


