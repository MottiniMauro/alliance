local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

local avoiding = false

-- /// Functions ///

local caculate_direction = function (left_data, right_data)
    if left_data and right_data then
        return {'2', '0'}
    elseif left_data then
        return {'1.5', '1'}
    elseif right_data then
        return {'1.5', '-1'}
    end
end

local avoid_direction = function (left_data, right_data)
    if left_data and right_data then
        return {'-1', '-1'}
    elseif left_data then
        return {'1', '-1'}
    elseif right_data then
        return {'1', '1'}
    end
end

local objective_handler = function (event, objective_output)
    print('=======object_hanlder========')
    if not avoiding and objective_output ~= nil then
        found_objective_left = objective_output[1]
        found_objective_right = objective_output[2]
        print(found_objective_right)
        print(found_objective_left)
        if found_objective_right or found_objective_left then
            objective_direction = caculate_direction (found_objective_left, found_objective_right)
            toroco.set_output {motors_setvel = objective_direction}
        else
            toroco.unset_output()
        end
    end
end

local object_hanlder = function (event, object_output)
    if object_output ~= nil then
        found_object_left = object_output[1]
        found_object_right = object_output[2]
        if found_object_right or found_object_left then
            avoiding = true
            direction = avoid_direction(found_object_left, found_object_right)
            toroco.set_output {motors_setvel = direction}
        else
            avoiding = false
        end
    else
        avoiding = false
    end
end

return toroco.trigger (input.found_objective, objective_handler),
       toroco.trigger (input.found_object, object_hanlder)