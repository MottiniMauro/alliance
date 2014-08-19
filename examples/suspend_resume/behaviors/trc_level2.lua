-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local device = toroco.device
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
        print ('level2 removed') 

        toroco.remove_behavior (behavior.trc_level2)

        print ('new level2 added') 

        local trc_level2 = {
            name = 'trc_level2';

            output_events = { }; 
            
            input_sources = {    
                trigger1 = device.mice.rightbutton;
            };

            input_handlers = {
                trigger1 = function (event, value)
                    if value then
                        print ('inhibition started')        
                        toroco.inhibit (device.mice.leftbutton, 2.5)
                        --toroco.suppress (device.mice.leftbutton, behavior.trc_sender, 2.5)

                    else
                        print ('inhibition released')   
                        toroco.release_inhibition (device.mice.leftbutton)
                        --toroco.release_suppression (device.mice.leftbutton, behavior.trc_sender)
                    end
                end
            };
        }
        toroco.add_behavior (trc_level2)
    end
end

return {
    output_events = { }; 
    
    input_handlers = {
        --trigger1 = handler_suspend;
        trigger1 = handler_remove;
    } 
}
