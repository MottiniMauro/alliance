local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior


local behaviors = {

    trc_sender = {
        output_targets = {
            motor1_setvel = device.trc_motor.setvel2mtr
        };

        input_sources = {
            gate_1 = device.mice.leftbutton,
            gate_2 = device.mice.rightbutton
        };
    };
};

toroco.add_behaviors (behaviors)

toroco.run ()


