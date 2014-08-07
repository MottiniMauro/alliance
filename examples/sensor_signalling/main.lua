local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


local behaviors = {

    trc_sender = {

        triggers = {
            trigger_left = device.mice.leftbutton,
            trigger_right = device.mice.rightbutton
        };
    };

    trc_receiver = {

        triggers = {
            trigger1 = behavior.trc_sender.repeater_event
        };

        output_targets = {
            motor1_setvel = device.trc_motor.setvel2mtr
        };
    };

};

toroco.add_behaviors (behaviors)

toroco.run ()


