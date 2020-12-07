-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local json = require "json"
local input = toroco.input

-- /// Functions ///

local sensory_feedback = function (event, camera_output)
    toroco.set_motivational_sensory_feedback(1)
end

return toroco.trigger (input.camera, sensory_feedback)
