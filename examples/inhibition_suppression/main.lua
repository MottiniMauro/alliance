local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

-- Method 1: use load_behavior and add_behavior.

--[[

local trc_level1 = toroco.load_behavior ('trc_level1')

trc_level1.triggers.trigger1.event = device.mice.leftbutton

trc_level1.output_targets.motor1_setvel = device.trc_motor.setvel2mtr

toroco.add_behavior (trc_level1)

local trc_level2 = toroco.load_behavior ('trc_level2')

trc_level2.triggers.trigger1.event = behavior.trc_level1.motor1_setvel

toroco.add_behavior (trc_level2)

--]]

-- Method 2
---[[

local trc_level1 = {
    name = 'trc_level1';

    output_events = { motor1_setvel = {}, motor2_setvel = {} }; 

    output_targets = {
        motor1_setvel = device.trc_motor.setvel2mtr
    };
    
    triggers = {
        trigger1 = { 
            event = device.mice.leftbutton;
                     
            callback = function (event, value) 
	            print (event, '=', value)
                toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
            end
        };
    } 
}
toroco.add_behavior (trc_level1)

local trc_level2 = {
    name = 'trc_level2';

    output_events = { }; 
    
    triggers = {
        trigger1 = { 
            event = device.mice.rightbutton;
                     
            callback = function (event, value)
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
        };
    } 
}
toroco.add_behavior (trc_level2)

--]]

-- Method 3: use add_behaviors.
--[[
local behaviors = {

    trc_level1 = {

        triggers = {
            trigger1 = device.mice.leftbutton
        };

        output_targets = {
            motor1_setvel = device.trc_motor.setvel2mtr
        };
    };

    trc_level2 = {

        triggers = {
            trigger1 = device.mice.rightbutton
        };
    };

};


toroco.add_behaviors (behaviors)
--]]

-- run toroco

toroco.run ()


