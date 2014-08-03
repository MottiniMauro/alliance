-- /// trc_receiver ///

local sched = require 'lumen.sched'
local toribio = require 'toribio'
local toroco = require 'toroco.toroco'

local M = {}

M.triggers = {}


-- /// Output events ///
-- Events emitted by the module.

M.output_events = {}


-- /// Callback functions ///

local callback1 = function (event, value) 

    -- local trc_sender = toroco.wait_for_behavior ('trc_sender')
    -- toroco.inhibit (trc_sender, 'motor1_setvel')

    local mice = toribio.wait_for_device ({module = 'mice'})

    if value then
        --toroco.inhibit (mice, 'leftbutton', 4)
        toroco.suppress (mice, 'leftbutton', 'trc_sender', 4)
    else
        --toroco.release_inhibition (mice, 'leftbutton')
        toroco.release_suppression (mice, 'leftbutton', 'trc_sender')
    end
end


-- /// Triggers ///

M.triggers.trigger1 = { callback = callback1 }


return M
