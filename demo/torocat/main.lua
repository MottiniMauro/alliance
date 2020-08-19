-- /// Torocó example - Line follower ///
-- main.lua

local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

local converter = function (event_value)
    return event_value
end

toroco.configure_polling (device.camera.get_value, 0.00001, converter)
toroco.configure_polling (device.pose.get_value, 0.00001, converter)
toroco.configure_polling (device.listener.send_updates, 0.1, converter)
toroco.configure_polling (device.listener.recive_updates, 0.1, converter)

toroco.load_behavior (behavior.follow, 'behaviors/follow', {found_mouse = {false, false}})
toroco.load_behavior (behavior.wander, 'behaviors/wander', {motors_values = {'0', '0'}})
toroco.load_behavior (behavior.avoid_collisions, 'behaviors/avoid_collisions', {found_object = {false, false}})
toroco.load_behavior (behavior.direction, 'behaviors/direction', {motors_setvel = {'0', '0'}})

toroco.set_inputs (behavior.follow, {
    camera = device.camera.get_value,
    pose = device.pose.get_value
})

toroco.set_inputs (behavior.wander, {
    update = device.camera.get_value
})

toroco.set_inputs (behavior.avoid_collisions, {
    camera = device.camera.get_value,
    pose = device.pose.get_value
})

toroco.set_inputs (behavior.direction, {
    found_mouse = behavior.follow.found_mouse,
    found_object = behavior.avoid_collisions.found_object
})

toroco.set_inputs (device.motors, {
    setvel2mtr = {
    	behavior.wander.motors_setvel,
    	behavior.direction.motors_setvel
    }
})

toroco.run ()


