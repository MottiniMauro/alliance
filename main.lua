local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'

local main = function()

    local trc_sender = toroco.new_behavior('trc_sender')

    trc_sender.triggers.trigger1.event = device['mice'].event.leftbutton
    trc_sender.triggers.trigger2.event = device.mice.event.rightbutton

    trc_sender.output.motor1_setvel = device.trc_motor.setvel2mtr

    local trc_receiver = toroco.new_behavior('trc_receiver')

    trc_receiver.triggers.trigger1.event = behavior.trc_sender.event.motor1_setvel
    trc_receiver.triggers.trigger2.event = behavior.trc_sender.event.motor2_setvel

end

toroco.run(main)


