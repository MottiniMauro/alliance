local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

-- /// Functions ///

local sensory_feedback = function (event, proximity_input)
	if proximity_input ~= nil then
		local data = json.decode(proximity_input)
		local objects = data["near_objects"]
	    for key, _ in pairs(objects) do
	        if string.match(key, "Ball1") then
	            toroco.set_motivational_sensory_feedback(1)
	            return
	        end
	    end
	end
    toroco.set_motivational_sensory_feedback(0)
end

return toroco.trigger (input.proximity, sensory_feedback)
