-- /// Torocó example - Wait for event trigger ///
-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// Functions ///

-- inhibition callback

local callback2 = function(event, value)
    
    if value then
        print ('\ninhibition started')
        toroco.send_output {clickbutton = {'inhibited!'; timeout = 2.5}}
    else
        print ('inhibition released')
        toroco.send_output {clickbutton = {'released!'; release = true}}
    end
end

return toroco.trigger (input.reset, callback2)

