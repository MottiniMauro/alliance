-- /// trc_level2 ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local output = toroco.output
local device = toroco.device
local behavior = toroco.behavior

-- /// Functions ///

-- suspend level1

local handler_suspend = function (event, value) 
	print (' ')

    if value then
        print ('level1 suspended')

        toroco.suspend_behavior (behavior.level1)

    else
        print ('level1 resumed') 
  
        toroco.resume_behavior (behavior.level1)
    end
end

-- swap level2 for level3

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
                        --toroco.inhibit (device.mice.leftbutton, 2.5)
                        toroco.suppress (device.mice.leftbutton, behavior.level1, 2.5, {'suppressed!'})

                    else
                        print ('\ninhibition released')   
                        --toroco.release_inhibition (device.mice.leftbutton)
                        toroco.release_suppression (device.mice.leftbutton, behavior.level1)
                    end
                end)
            },

            {
            }
        )

        toroco.set_inputs (behavior.level3, {
            trigger1 = device.mice.rightbutton
        })

        print ('level3 added')
    end
end

-- triggers

local trigger1 = toroco.trigger (input.trigger1, handler_suspend)
--local trigger1 = toroco.trigger (input.trigger1, handler_swap)

-- add behavior

toroco.add_behavior (
    {
        trigger1
    },

    {
    }
)
