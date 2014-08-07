-- /// trc_level1 ///

local toroco = require 'toroco.toroco'

local M = {}

M.triggers = {}

-- /// Output events ///
-- Events emitted by the module.

M.output_events = {motor1_setvel = {}, motor2_setvel = {}}


-- /// Callback functions ///

local callback1 = function(event, v) 
	print (event, '=', v)
    toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
end


-- /// Triggers ///

M.triggers.trigger1 = { callback = callback1 }

return M
