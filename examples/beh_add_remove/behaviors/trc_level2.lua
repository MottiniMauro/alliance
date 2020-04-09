-- /// Torocó - Remove ///
-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local device = toroco.device
local behavior = toroco.behavior

-- /// Functions ///

-- remove level2 and add level3

local handler_swap = function (event, value) 
    if value then

        -- remove level2

        toroco.remove_behavior (behavior.level2)
        print ('\nlevel2 removed') 

        -- add level3

        toroco.add_behavior (
            behavior.level3,

            {
                toroco.trigger (input.trigger1, function (event, value)
                    if value then
                        print ('\ninhibition started')

                        toroco.send_output {clickbutton = { false }}

                    else
                        print ('\ninhibition released')

                        toroco.send_output {clickbutton = {release = true}}
                    end
                end)
            }
        )

        toroco.set_inputs (behavior.level1, {
            trigger1 = {
                device.mice.leftbutton,
                behavior.level3.clickbutton
            }
        })

        toroco.set_inputs (behavior.level3, {
            trigger1 = device.mice.rightbutton
        })

        print ('level3 added')
    end
end

return toroco.trigger (input.trigger1, handler_swap)

