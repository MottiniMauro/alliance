-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input
local params = toroco.params

-- /// Functions ///
local findBalls = function (raw_data)
    if raw_data ~= nil then
        data = json.decode(raw_data)
        local visible_objects = data['visible_objects']
        if visible_objects  ~= nil then
            for key, visible_object in ipairs(visible_objects) do
                if visible_object['name'] ~= nil and string.match(key, "Ball") then
                    return true
                end
            end
        end
    end
    return false
end

local handler1 = function (event, camera_output)
    local found_left = findBalls(camera_output[1])
    local found_right = findBalls(camera_output[2])

    if not found_left and not found_right then
        toroco.set_output {motors_setvel = {'0', '-1'}}
    else
        toroco.unset_output()
    end
end

return toroco.trigger (input.update, handler1)



