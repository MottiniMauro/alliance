-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

-- initialize behaviors

toroco.load_behavior (behavior.red_follower, 'behaviors/red_follower',
    {motors_lx = {15, 50}, motors_l = {30, 50},
    motors_f = {50, 50},
    motors_r = {50, 30}, motors_rx = {50, 15}})
    
toroco.load_behavior (behavior.trq_follower, 'behaviors/trq_follower',
    {motors_lx = {15, 50}, motors_l = {30, 50},
    motors_f = {50, 50},
    motors_r = {50, 30}, motors_rx = {50, 15}})

-- initialize inputs

toroco.set_inputs (behavior.red_follower, {
    update = device.camera.update_red
})

toroco.set_inputs (behavior.trq_follower, {
    update = device.camera.update_trq
})

-- run toroco

toroco.run ('toribio2.conf')


