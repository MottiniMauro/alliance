-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input
local object_position = {0, 0, 0}
local cat_position = {0, 0, 0}

-- /// Functions ///

local findObject = function (raw_data)
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

local getPosition = function (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        return {
            data['x'],
            data['y'],
            data['z']
        }
    end
end

local calculate_distance = function (my_position, objective_position)
    a = my_position[1] - objective_position[1]
    b = my_position[2] - objective_position[2]
    return math.sqrt(
        (a * a) + (b * b)
    )
end


local camera_handler = function (event, camera_output)
    local found_left = findObject (camera_output[1])
    local found_right = findObject (camera_output[2])

    if found_left or found_right then
        object_distance = calculate_distance(cat_position, object_position)
        if object_distance < 3 then
            toroco.set_output {found_object = {found_left, found_right}}
        else
            toroco.set_output {found_object = {false, false}}
        end
    else
        toroco.set_output {found_object = {false, false}}
    end
end

local pose_handler = function (event, pose_output)
    cat_position = getPosition (pose_output)
end

return toroco.trigger (input.camera, camera_handler),
       toroco.trigger (input.pose, pose_handler)



