-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


-- initialize behaviors

toroco.load_behavior (behavior.move_forward, 'behaviors/trc_move_forward')
toroco.load_behavior (behavior.turn_left, 'behaviors/trc_turn_left')
toroco.load_behavior (behavior.turn_right, 'behaviors/trc_turn_right')

-- initialize inputs
---[[
toroco.set_inputs (behavior.turn_left, {
    trigger_left = device.trc_grey_left.get_value 
})

toroco.set_inputs (behavior.turn_right, {
    trigger_right = device.trc_grey_right.get_value
})

toroco.set_inputs (device.trc_motor, {
    setvel2mtr = {
        behavior.move_forward.motors_setvel,
        behavior.turn_left.motors_setvel,
        behavior.turn_right.motors_setvel
    }
})
--]]

-- run toroco

toroco.run ()


