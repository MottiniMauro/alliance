local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


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

-- run toroco

toroco.run ()


