-- /// trc_receiver ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local output = toroco.output

-- /// functions ///

local handler1 = function (event, side, value) 

    if value then
        if side == 'left' then
            toroco.send_output {motor1_setvel = {99, 0}}
        else
            toroco.send_output {motor1_setvel = {0, 99}}
        end
    end
end

-- triggers

local trigger1 = toroco.trigger (input.trigger1, handler1)

-- add behavior

toroco.add_behavior (
    {
        trigger1
    }, 

    {
        output.motor1_setvel
    }
)
