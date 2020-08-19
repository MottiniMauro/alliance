-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

-- /// Functions ///

local findRabbit = function (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        local visible_objects = data['visible_objects']
        for key, visible_object in ipairs(visible_objects) do
            if visible_object['name'] ~= nil and visible_object['name'] == "RABBIT" then
                return true
            end
        end
    end
    return false
end

local camera_handler = function (event, camera_output)
    print('following rabbit')
    local found_left = findRabbit (camera_output[1])
    local found_right = findRabbit (camera_output[2])
    toroco.set_output {found_objective = {found_left, found_right}}
end

return toroco.trigger (input.camera, camera_handler)



