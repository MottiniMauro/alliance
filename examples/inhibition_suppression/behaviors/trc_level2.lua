-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local device = toroco.device
local behavior = toroco.behavior

-- /// Handler functions ///

local handler1 = function (event, value) 
	print (' ')

    if value then
        print ('inhibition started')        

        toroco.send_output {clickbutton = {'suppressed!'; timeout = 2.5}}
    else
        print ('inhibition released')   

        toroco.send_output {clickbutton = {'released!'; release = true}}       -- should be reset_output()
    end
end

return toroco.trigger (input.trigger1, handler1)

