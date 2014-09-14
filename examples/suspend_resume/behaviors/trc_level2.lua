-- /// Torocó example - Suspend and resume behaviors ///
-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local device = toroco.device
local behavior = toroco.behavior

-- /// Functions ///

-- suspend and resume level1

local handler_suspend_resume = function (event, value) 
	print (' ')

    if value then
        print ('level1 suspended')

        toroco.suspend_behavior (behavior.level1)

    else
        print ('level1 resumed') 
  
        toroco.resume_behavior (behavior.level1)
    end
end

return toroco.trigger (input.trigger1, handler_suspend_resume)

