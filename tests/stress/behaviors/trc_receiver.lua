-- /// trc_receiver ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local start = nil
local count = 0
local handler1 = function (event, value1, value2)

    if not start then
        start = true
        count = 0
        print ('\nTest started!')
    end

    if value1 == 'end' then
        print ('Test completed!')
        print ('Total transmitted', count, 'of', value2, 'packets.')
        start = nil
    else
        count = count + 1
    end

    --print (value1, value2)
    toroco.send_output {pong = {value1..','..value2..'\n'}}
end

return toroco.trigger (input.trigger1, handler1)



