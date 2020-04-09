-- /// trc_avoid ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local running = false

local handler1 = function (event, value)

    if value == 0 then
        running = not running
    end

    if running then
        print ('Robot running!')
        toroco.set_output {enable_motors = {true, true}}
    else
        print ('Robot stopped!')
        toroco.set_output {enable_motors = {false, false}}
    end
end

return toroco.trigger (input.update, handler1)



