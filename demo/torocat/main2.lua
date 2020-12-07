-- /// Torocó example - Line follower ///
-- main.lua

local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior
local behavior_set = toroco.behavior_set
local motivational_behavior = toroco.motivational_behavior

local basic_converter = function (event_value)
    return event_value
end

local recive_converter = function (event_value)
    if event_value ~= nil then
        message = event_value:gmatch("([^,]+),?")
        robot_id = message()
        behavior = message()
        toroco.robot_message(robot_id, behavior)
    end
    return event_value
end

toroco.configure_polling (device.camera.get_value, 0.00001, basic_converter)
toroco.configure_polling (device.pose.get_value, 0.00001, basic_converter)
toroco.configure_polling (device.listener.recive_updates, 0.1, recive_converter)

toroco.configure_notifier (device.listener.send_updates)

toroco.load_behavior (behavior.follow_rabbit, 'behaviors/follow_rabbit', {found_objective = {false, false}})
toroco.load_behavior (behavior.follow_mouse, 'behaviors/follow_mouse', {found_objective = {false, false}})

toroco.load_behavior (behavior.wander, 'behaviors/wander', {motors_values = {'0', '0'}})
toroco.load_behavior (behavior.avoid_collisions, 'behaviors/avoid_collisions', {found_object = {false, false}})
toroco.load_behavior (behavior.direction, 'behaviors/direction', {motors_setvel = {'0', '0'}})

toroco.set_inputs (behavior.follow_rabbit, {
    camera = device.camera.get_value,
    pose = device.pose.get_value
})

toroco.set_inputs (behavior.follow_mouse, {
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
    found_objective = {
        behavior.follow_rabbit.found_objective,
        behavior.follow_mouse.found_objective
    },
    found_object = behavior.avoid_collisions.found_object
})

toroco.set_inputs (device.motors, {
    setvel2mtr = {
    	behavior.wander.motors_setvel,
    	behavior.direction.motors_setvel
    }
})

toroco.load_behavior_set (
    behavior_set.follow_mouse,
    {
        behavior.follow_mouse,
    }
)

toroco.load_behavior_set (
    behavior_set.follow_rabbit,
    {
        behavior.follow_rabbit,
    }
)

toroco.load_motivational_behavior (
    motivational_behavior.follow_mouse,
    'motivational_behaviors/follow_mouse',
    behavior_set.follow_mouse,
    {
        impatience = {
            slow_rate = 1,
            fast_rate = 2
        },
        acquiescence = {
            yield_time = 5,
            give_up_time = 7
        }
    }
)

toroco.load_motivational_behavior (
    motivational_behavior.follow_rabbit,
    'motivational_behaviors/follow_rabbit',
    behavior_set.follow_rabbit,
    {
        impatience = {
            slow_rate = 1,
            fast_rate = 2
        },
        acquiescence = {
            yield_time = 5,
            give_up_time = 7
        }
    }
)

toroco.set_inputs (motivational_behavior.follow_mouse, {
    camera = device.camera.get_value
})

toroco.set_inputs (motivational_behavior.follow_rabbit, {
    camera = device.camera.get_value
})


toroco.run()



