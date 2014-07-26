local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

-- Method 1: use load_behavior and add_behavior.

--[[

local trc_sender = toroco.load_behavior ('trc_sender')

trc_sender.triggers.trigger1.event = device.mice.event.leftbutton
trc_sender.triggers.trigger2.event = device.mice.event.rightbutton

trc_sender.output_targets.motor1_setvel = device.trc_motor.setvel2mtr

toroco.add_behavior (trc_sender)

local trc_receiver = toroco.load_behavior ('trc_receiver')

trc_receiver.triggers.trigger1.event = behavior.trc_sender.event.motor1_setvel
trc_receiver.triggers.trigger2.event = behavior.trc_sender.event.motor2_setvel

toroco.add_behavior (trc_receiver)

--]]

-- Method 2: use add_behaviors.

---[[
local behaviors = {

    trc_sender = {

        triggers = {
            trigger1 = device.mice.event.leftbutton,
            trigger2 = device.mice.event.rightbutton
        };

        output_targets = {
            motor1_setvel = device.trc_motor.setvel2mtr
        };
    };

    trc_receiver = {

        triggers = {
            trigger1 = behavior.trc_sender.event.motor1_setvel,
            trigger2 = behavior.trc_sender.event.motor2_setvel
        };
    };

};


toroco.add_behaviors (behaviors)
--]]

-- run toroco

toroco.run ()


