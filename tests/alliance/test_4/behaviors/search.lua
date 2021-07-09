local toroco = require 'toroco.toroco'
local input = toroco.input

local camera_handler = function (event, camera_output)
    toroco.set_output {found_objective = {false, false}}
end

return toroco.trigger (input.camera, camera_handler)
