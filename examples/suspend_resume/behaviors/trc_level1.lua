-- /// trc_level1 ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local output = toroco.output

-- /// Functions ///

local handler1 = function (event, value)
	print (' ')
	print (event, '=', value)

    toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
end

-- triggers

local trigger1 = toroco.trigger (input.trigger1, handler1)

-- add behavior

toroco.add_behavior (
    {
        trigger1
    },

    {
        output.motor1_setvel,
        output.motor2_setvel
    }
)
