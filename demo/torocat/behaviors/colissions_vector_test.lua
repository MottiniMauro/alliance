-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input
local object_position = {0, 0}
local cat_position = {0, 0}

-- /// Functions ///

function findObject (raw_data)
	if raw_data ~= nil then
		data = json.decode(raw_data)
		local visible_objects = data['visible_objects']
		for key, visible_object in ipairs(visible_objects) do
		    if visible_object['name'] ~= nil and visible_object['name'] == "OBJECT" then
		        object_position = visible_object['position']
                return true
		    end
		end
	end
    return false
end

function getPosition (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        return {
            data['x'],
            data['y']
        }
    end
end

function calculate_distance(my_position, objective_position)
    return {
        objective_position[1] + my_position[1],
        objective_position[2] + my_position[2]
    }
end

function vector_oposite(objective_position)
    return {
        (1 / objective_position[1]) * (-1),
        (1 / objective_position[2]) * (-1)
    }
end

local camera_handler = function (event, camera_output)
    -- print('===a====camera_handler========')
    -- print(camera_output)
    local found_left = findObject (camera_output[1])
    local found_right = findObject (camera_output[2])

    if found_left or found_right then
        print(cat_position)
        print()
        object_distance = calculate_distance(cat_position, object_position)
        avoid_object_direction = vector_oposite(object_distance)
        toroco.set_output {direction_object =  avoid_object_direction}
    else
        toroco.set_output {direction_object = nil}
    end
end

local pose_handler = function (event, pose_output)
    -- print('====a===pose_handler========')
    -- print(pose_output)
    cat_position = getPosition (pose_output)
end

return toroco.trigger (input.camera, camera_handler),
       toroco.trigger (input.pose, pose_handler)



