-- /// Torocó example - Sensor signalling ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


-- initialize behaviors

--toroco.load_behavior (behavior.sender, 'behaviors/trc_sender')
toroco.load_behavior (behavior.mover, 'behaviors/motor_mover')


toroco.set_inputs (behavior.mover, {
    trigger_distance = device.distance.triggered
})
-- load devices
toroco.set_inputs (device.mtr_izq, {
	move = {behavior.mover.izq_move},
})
toroco.set_inputs (device.mtr_der, {
        move = {behavior.mover.der_move},
})

-- run Toroco

toroco.run ()


