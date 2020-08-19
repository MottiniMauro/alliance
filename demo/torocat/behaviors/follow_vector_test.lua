-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

local mouse_position = {0, 0}  -- Use array for multiple ones
local cat_position = {0, 0}

-- /// Functions ///

function findMouse (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        local visible_objects = data['visible_objects']
        for key, visible_object in ipairs(visible_objects) do
            if visible_object['name'] ~= nil and visible_object['name'] == "MOUSE" then
                mouse_position = visible_object['position']
                return true
            end
        end
    end
    return false
end

local camera_handler = function (event, camera_output)
    local found_left = findMouse (camera_output[1])
    local found_right = findMouse (camera_output[2])

    if found_left or found_right then
        toroco.set_output {direction_mouse = calculate_distance(cat_position, mouse_position)}
    else
        toroco.set_output {direction_mouse = nil}
    end
end

local pose_handler = function (event, pose_output)
    cat_position = getPosition (pose_output)
end

return toroco.trigger (input.camera, camera_handler),
       toroco.trigger (input.pose, pose_handler)



