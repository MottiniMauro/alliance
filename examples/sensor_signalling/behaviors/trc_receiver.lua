-- /// trc_receiver ///

local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

local M = {}

M.triggers = {}


-- /// Output events ///
-- Events emitted by the module.

M.output_events = {}


-- /// Callback functions ///

local callback1 = function (event, value) 

    if value then
        --toroco.inhibit (device.mice.leftbutton, 4)
        toroco.suppress (device.mice.leftbutton, behavior.trc_sender, 4)
    else
        --toroco.release_inhibition (device.mice.leftbutton)
        toroco.release_suppression (device.mice.leftbutton, behavior.trc_sender)
    end
end


-- /// Triggers ///

M.triggers.trigger1 = { callback = callback1 }


return M
