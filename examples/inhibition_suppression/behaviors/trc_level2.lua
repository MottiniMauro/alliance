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

        --toroco.inhibit (device.mice.leftbutton, 2.5)
        toroco.suppress (device.mice.leftbutton, behavior.level1, 2.5, {'suppressed!'})

    else
        print ('inhibition released')   

        --toroco.release_inhibition (device.mice.leftbutton)
        toroco.release_suppression (device.mice.leftbutton, behavior.level1)
    end
end

return toroco.trigger (input.trigger1, handler1)

