-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

-- initialize behaviors

toroco.load_behavior (behavior.move_forward, 'behaviors/trc_move_forward', {motors_values = {20, 20}})

toroco.load_behavior (behavior.red_follower, 'behaviors/red_follower', {
    motors_lx = {10, 50},
    motors_l = {20, 50},
    motors_f = {50, 50},
    motors_r = {50, 20},
    motors_rx = {50, 10}
})
    
toroco.load_behavior (behavior.trq_follower, 'behaviors/trq_follower', {
    motors_lx = {50, 10}, 
    motors_l = {50, 15},
    motors_f = {40, 10},
    motors_r = {15, 50}, 
    motors_rx = {10, 50}
})

-- initialize inputs

toroco.set_inputs (behavior.red_follower, {
    update = device.camera.update_red
})

toroco.set_inputs (behavior.trq_follower, {
    update = device.camera.update_trq
})

toroco.set_inputs (device.servo_motors, {
    setvel2mtr = {
        behavior.move_forward.motors_setvel,
        behavior.trq_follower.motors_setvel,
        behavior.red_follower.motors_setvel
    }
})

-- run toroco

toroco.run ('toribio2.conf')


