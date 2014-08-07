-- /// trc_sender ///

local toroco = require 'toroco.toroco'

local M = {}

M.triggers = {}

-- /// Output events ///
-- Events emitted by the module.

M.output_events = {repeater_event = {}}


-- /// Callback functions ///

local callback_left = function(event, v) 
	print (event, '=', v)
    toroco.send_output {repeater_event = {'left', v}}
end

local callback_right = function(event, v) 
	print (event, '=', v)
    toroco.send_output {repeater_event = {'right', v}}
end


-- /// Triggers ///

M.triggers.trigger_left = { callback = callback_left }

M.triggers.trigger_right = { callback = callback_right }

return M
