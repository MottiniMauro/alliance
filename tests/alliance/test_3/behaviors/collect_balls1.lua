-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

-- /// Functions ///

local findBalls = function (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        local visible_objects = data['visible_objects']
        for key, visible_object in ipairs(visible_objects) do
            local name = visible_object['name']
            local height = visible_object['position'][3]
            if name ~= nil and string.match(name, "Ball1") and height > 0.35 then
                return true
            end
        end
    end
    return false
end

local camera_handler = function (event, camera_output)
    local found_left = findBalls (camera_output[1])
    local found_right = findBalls (camera_output[2])
    toroco.set_output {found_objective = {found_left, found_right}}
end

return toroco.trigger (input.camera, camera_handler)



