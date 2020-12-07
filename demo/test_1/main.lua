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
toroco.configure_polling (device.proximity.get_value, 0.00001, basic_converter)
toroco.configure_polling (device.listener.recive_updates, 0.1, recive_converter)

toroco.configure_notifier (device.listener.send_updates)

toroco.load_behavior (behavior.collect_balls2, 'behaviors/collect_balls2', {found_objective = {false, false}})
toroco.load_behavior (behavior.collect_balls1, 'behaviors/collect_balls1', {found_objective = {false, false}})

toroco.load_behavior (behavior.wander, 'behaviors/wander', {motors_values = {'0', '0'}})
toroco.load_behavior (behavior.direction, 'behaviors/direction', {motors_setvel = {'0', '0'}})

toroco.set_inputs (behavior.collect_balls2, {
    camera = device.camera.get_value,
})

toroco.set_inputs (behavior.collect_balls1, {
    camera = device.camera.get_value,
})


toroco.set_inputs (behavior.wander, {
    update = device.camera.get_value
})


toroco.set_inputs (behavior.direction, {
    found_objective = {
        behavior.collect_balls2.found_objective,
        behavior.collect_balls1.found_objective
    }
})

toroco.set_inputs (device.motors, {
    setvel2mtr = {
    	behavior.wander.motors_setvel,
    	behavior.direction.motors_setvel
    }
})

toroco.load_behavior_set (
    behavior_set.collect_balls1,
    {
        behavior.collect_balls1,
    }
)

toroco.load_behavior_set (
    behavior_set.collect_balls2,
    {
        behavior.collect_balls2,
    }
)

toroco.load_motivational_behavior (
    motivational_behavior.collect_balls1,
    'motivational_behaviors/collect_balls1',
    behavior_set.collect_balls1,
    {
        impatience = {
            slow_rate = 1,
            fast_rate = 5
        },
        acquiescence = {
            yield_time = 20,
            give_up_time = 20
        }
    }
)

toroco.load_motivational_behavior (
    motivational_behavior.collect_balls2,
    'motivational_behaviors/collect_balls2',
    behavior_set.collect_balls2,
    {
        impatience = {
            slow_rate = 1,
            fast_rate = 5
        },
        acquiescence = {
            yield_time = 20,
            give_up_time = 20
        }
    }
)

toroco.set_inputs (motivational_behavior.collect_balls1, {
    proximity = device.proximity.get_value
})

toroco.set_inputs (motivational_behavior.collect_balls2, {
    proximity = device.proximity.get_value
})

toroco.run()