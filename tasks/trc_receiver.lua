-- /// trc_receiver ///

local sched = require 'lumen.sched'
local toribio = require 'toribio'
local toroco = require 'toroco'

-- /// local variables ///

local M = {}

local triggers = {}
local devices = {}

-- /// Callback functions ///

-- prints the event for trigger1

local callback_trigger1 = function (event, ...) 
	print (event, '=', ...)
end

-- inhibits 'leftbutton'

local callback_trigger2 = function (event, value) 

    -- local trc_sender = toroco.wait_for_behavior ('trc_sender')
    -- toroco.inhibit (trc_sender, 'motor1_setvel')

    local mice = toribio.wait_for_device ({module = 'mice'})

    if value then
        toroco.inhibit (mice, 'leftbutton')
    else
        toroco.release_inhibition (mice, 'leftbutton')
    end
end

-- /// Triggers ///

triggers.trigger1 = {event = 'motor1_setvel', callback = callback_trigger1}

triggers.trigger2 = {event = 'motor2_setvel', callback = callback_trigger2}

-- /// Output events ///
-- Events emitted by the module.

local output_events = {}

-- /// Init function ///

M.init = function(conf)

	toroco.register_behavior(conf, triggers, output_events)
end

return M
