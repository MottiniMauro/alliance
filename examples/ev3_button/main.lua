-- /// Torocó example - Sensor signalling ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


-- initialize behaviors

toroco.load_behavior (behavior.sender, 'behaviors/trc_sender')
toroco.load_behavior (behavior.mover, 'behaviors/motor_mover')

toroco.set_inputs (behavior.sender, {
    trigger_button = device.btn1.pressed
})
toroco.set_inputs (behavior.mover, {
    trigger_button = device.btn0.pressed 
})
-- load devices
toroco.set_inputs (device.mtr1, {
	stop = {behavior.sender.motor_stop},
	move = {behavior.mover.motor_move},
})

-- run Toroco

toroco.run ()


