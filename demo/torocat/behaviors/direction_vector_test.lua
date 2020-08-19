-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

local object_vector = {0, 0} -- Use array for multiple ones
local mouse_vector = {0, 0}
local direction_vector = {0, 0}
local vector_speed = {0, 0}

-- /// Functions ///
function update_direction()
    direction_vector = {
        object_vector[1] + mouse_vector[1],
        object_vector[2] + mouse_vector[2]
    }
end

function myDot(a, b)
    return (a[1] * b[1]) + (a[2] * b[2])
end

function myMag(a)
    return math.sqrt((a[1] * a[1]) + (a[2] * a[2]))
end

local mouse_handler = function (event, mouse_output)
    -- print('==mouse_handler==')
    mouse_vector = mouse_output
    if object_vector ~= nil or mouse_vector ~= nil then
        update_direction()
        -- print('---')
        -- print(direction_vector[1])
        -- print(direction_vector[2])
        -- print(vector_speed[1])
        -- print(vector_speed[2])
        angle = math.acos(myDot(direction_vector, vector_speed) / (myMag(direction_vector) * myMag(vector_speed)))
        -- print(myDot(direction_vector, vector_speed))
        -- print(myMag(direction_vector) * myMag(vector_speed))
        -- print(angle)
        toroco.set_output {motors_setvel = {'1', tostring(angle)}}
        vector_speed = direction_vector
    else
        toroco.unset_output()
    end
end

local object_hanlder = function (event, object_output)
    -- print('==object_hanlder==')
    object_vector = object_output

    if object_vector ~= nil or mouse_vector ~= nil then
        update_direction()
        -- print('---')
        -- print(direction_vector[1])
        -- print(direction_vector[2])
        -- print(vector_speed[1])
        -- print(vector_speed[2])
        angle = math.acos(myDot(direction_vector, vector_speed) / (myMag(direction_vector) * myMag(vector_speed)))
        -- print(myDot(direction_vector, vector_speed))
        -- print(myMag(direction_vector) * myMag(vector_speed))
        -- print(angle)
        toroco.set_output {motors_setvel = {'1', tostring(angle)}}
        vector_speed = direction_vector
    else
        toroco.unset_output()
    end
end

return toroco.trigger (input.direction_mouse, mouse_handler),
       toroco.trigger (input.direction_object, object_hanlder)