-- Toroco deviceloader to test signaling

local toribio = require 'toribio'
local selector = require 'lumen.tasks.selector'
local sched = require 'lumen.sched'
local luapru = require 'luapru'


local M = {}

local devices = {}

local add_device = function(num, name, type)

    local update = {} --event
    
    local device = {}
    
    --- Name of the device
    device.name = name

    device.type = type

    --- Module name (in this case, 'pru').
    device.module = 'pru'

    --- Events emitted by this device.
    -- @table events
    -- @field update_value Sensor value change.
    device.events={
        update = update
    }

    devices[num] = device
    
    toribio.add_device(device)
end

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function (conf)

    conf = conf or {}
        
    luapru.init_pru()

    for k, v in pairs(conf.sensor or {}) do
        luapru.add_sensor(v.type, v.channel, v.threshold_high, v.threshold_low)

        add_device (k, v.name, v.type)
    end

    luapru.start_pru()

    local read_sensor = function()
        return luapru.wait_for_pru_event()
    end

    selector.fork_run (read_sensor, nil, function(_, msg)
        
        if msg then
            local sensor_num, value = msg:match (';([^,]+),([^,]+)$')
            if sensor_num then
                sensor_num = sensor_num + 1
                value = tonumber(value)
                print ('sensor_num', sensor_num, 'value', value) 
                
                sched.signal (devices[sensor_num].events.update, value)
            end
        end

        return true
    end)
end

return M

