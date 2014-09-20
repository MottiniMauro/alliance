-- /// Torocó example - Line follower ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


-- initialize behaviors

toroco.load_behavior (behavior.move_forward, 'behaviors/trc_move_forward')
toroco.load_behavior (behavior.turn_left, 'behaviors/trc_turn', {motors_values = {1, 30, 1, 100}})
toroco.load_behavior (behavior.turn_right, 'behaviors/trc_turn', {motors_values = {1, 100, 1, 30}})

--
local converter = function (event_value)
    return event_value
end

toroco.configure_polling (device.trc_grey_left.get_value, 0.1, converter)

-- initialize inputs
---[[
toroco.set_inputs (behavior.turn_left, {
    trigger_turn = device.trc_grey_left.get_value
})

toroco.set_inputs (behavior.turn_right, {
    trigger_turn = device.trc_grey_right.get_value
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


