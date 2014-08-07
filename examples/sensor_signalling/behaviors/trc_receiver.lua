-- /// trc_receiver ///

local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

local M = {}

M.triggers = {}


-- /// Output events ///
-- Events emitted by the module.

M.output_events = {motor1_setvel = {}}


-- /// Callback functions ///

local callback1 = function (event, side, value)

    if value then
        if side == 'left' then
            toroco.send_output {motor1_setvel = {99, 0}}
        else
            toroco.send_output {motor1_setvel = {0, 99}}
        end
    end
end


-- /// Triggers ///

M.triggers.trigger1 = { callback = callback1 }


return M
