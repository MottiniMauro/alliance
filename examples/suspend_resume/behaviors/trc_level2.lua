-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local behavior = toroco.behavior

-- /// Handler functions ///

local handler_suspend = function (event, value) 
	print (' ')

    if value then
        print ('level1 suspended')

        toroco.suspend_behavior (behavior.trc_level1)

    else
        print ('level1 resumed') 
  
        toroco.resume_behavior (behavior.trc_level1)
    end
end

local handler_remove = function (event, value) 
    if value then
        print ('level1 removed') 

        toroco.remove_behavior (behavior.trc_level1)
    end
end

return {
    output_events = { }; 
    
    input_handlers = {
        trigger1 = handler_suspend;
        --trigger1 = handler_remove;
    } 
}
