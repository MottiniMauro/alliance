local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


local behaviors = {

    trc_line_follower = {

        triggers = {
            trigger1 = device.trc_grey_left.get_value,
            trigger2 = device.trc_grey_right.get_value
        };

        output_targets = {
            motors_setvel = device.trc_motor.setvel2mtr
        };
    };
};


toroco.add_behaviors (behaviors)
toroco.run ()


