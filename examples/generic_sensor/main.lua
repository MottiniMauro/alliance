-- /// Torocoó example - generic sensor ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


-- initialize behavior

toroco.load_behavior (behavior.sensor, 'behaviors/sensor')

toroco.set_inputs (behavior.sensor, {
    trigger = device.sensor.triggered
})

-- load devices
toroco.set_inputs (device.mtr1, {
	move = {behavior.sensor.motor_move}
})

-- run Toroco

toroco.run ()


