local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Functions ///

local caculate_direction = function (left_data, right_data)
    if left_data and right_data then
        return {'0.4', '0'}
    elseif left_data then
        return {'0.0', '0.5'}
    elseif right_data then
        return {'0.0', '-0.5'}
    end
end

local objective_handler = function (event, objective_output)
    if objective_output ~= nil then
        found_objective_left = objective_output[1]
        found_objective_right = objective_output[2]
        if found_objective_right or found_objective_left then
            objective_direction = caculate_direction (found_objective_left, found_objective_right)
            toroco.set_output {motors_setvel = objective_direction}
        else
            toroco.unset_output()
        end
    else
        toroco.unset_output()
    end
end

return toroco.trigger (input.found_objective, objective_handler)