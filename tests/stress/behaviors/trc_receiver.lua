-- /// trc_receiver ///

local toroco = require 'toroco.toroco'
local sched = require 'lumen.sched'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local start = nil
local count = 0
local handler1 = function (event, start_time, value1, value2, value3)

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
    
    --sched.sleep (0.03)

    --print (value1, value2)
    toroco.send_output {pong = {start_time, value1, value2, value3}}
end

return toroco.trigger (input.trigger1, handler1)



