local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior

-- Method 1: use load_behavior and add_behavior.

--[[

local trc_level1 = toroco.load_behavior ('trc_level1')

trc_level1.input_sources.trigger1 = device.mice.leftbutton

trc_level1.output_targets.motor1_setvel = device.trc_motor.setvel2mtr

toroco.add_behavior (trc_level1)

local trc_level2 = toroco.load_behavior ('trc_level2')

trc_level2.input_sources.trigger1 = device.mice.rightbutton

toroco.add_behavior (trc_level2)

--]]

-- Method 2
--[[

local trc_level1 = {
    name = 'trc_level1';

    output_events = { motor1_setvel = {}, motor2_setvel = {} }; 

    output_targets = {
        motor1_setvel = device.trc_motor.setvel2mtr
    };
    
    input_sources = {    
        trigger1 = device.mice.leftbutton;
    };

    input_handlers = {
        trigger1 = function (event, value) 
            print (event, '=', value)
            toroco.send_output {motor1_setvel = {1, 33}, motor2_setvel = {0, 99}}
        end
    };
}
toroco.add_behavior (trc_level1)


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
toroco.add_behavior (trc_level2)

--]]

-- Method 3: use add_behaviors.
---[[
local behaviors = {

    trc_level1 = {

        input_sources = {
            trigger1 = device.mice.leftbutton
        };

        output_targets = {
            motor1_setvel = device.trc_motor.setvel2mtr
        };
    };

    trc_level2 = {

        input_sources = {
            trigger1 = device.mice.rightbutton
        };
    };

};


toroco.add_behaviors (behaviors)
--]]

-- run toroco

toroco.run ()


