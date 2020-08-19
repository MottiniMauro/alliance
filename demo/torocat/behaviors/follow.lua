-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

-- /// Functions ///

local findMouse = function (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        local visible_objects = data['visible_objects']
        for key, visible_object in ipairs(visible_objects) do
            if visible_object['name'] ~= nil and visible_object['name'] == "MOUSE" then
                return true
            end
        end
    end
    return false
end

local camera_handler = function (event, camera_output)
    local found_left = findMouse (camera_output[1])
    local found_right = findMouse (camera_output[2])
    toroco.set_output {found_mouse = {found_left, found_right}}
end

return toroco.trigger (input.camera, camera_handler)



