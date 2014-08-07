require 'toroco.dsl'

local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

local main = function()

    Behavior {
        id = 'test';
        
        Output {
            id = 'output1';    
        };

        Trigger {
            id = 'trigger1';

            event = device.mice.event.leftbutton;

            callback = function(event, ...)
                print (event, '=', ...)
                output1(45, 50)
            end;    
        };

        Trigger {
            id = 'trigger2';

            event = device.mice.event.rightbutton;

            callback = function(event, ...)
                print (event, '=', ...)
            end;    
        };
    }

    Behavior {
        id = 'test2';

        Trigger {
            id = 'trigger10';

            event = behavior.test.event.output1;

            callback = function(event, v, ...)
                print (event, '=', ...)
                inhibit_mice.active = v
            end;    
        };

        Inhibition {
            id = 'inhibit_mice';
            event = device.mice.event.leftbutton;
        }

    }


end

toroco.run(main)
