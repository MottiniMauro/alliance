-- /// Torocoó example - camera  ///
-- main.lua


local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local behavior = require 'toroco.behavior'


-- initialize behavior

toroco.load_behavior (behavior.sensor, 'behaviors/sensor')

toroco.set_inputs (behavior.sensor, {
    update = device.sensor.update
})


-- run Toroco

toroco.run ()


