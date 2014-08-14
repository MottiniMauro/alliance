-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

-- /// Handler functions ///

local handler1 = function (event, value) 

    if value then
        print ('inhibition started')        

        toroco.inhibit (device.mice.leftbutton, 4)
        --toroco.suppress (device.mice.leftbutton, behavior.trc_sender, 4)

    else
        print ('inhibition released')   
  
        toroco.release_inhibition (device.mice.leftbutton)
        --toroco.release_suppression (device.mice.leftbutton, behavior.trc_sender)
    end
end

return {
    output_events = { }; 
    
    input_handlers = {
        trigger1 = handler1;
    } 
}
