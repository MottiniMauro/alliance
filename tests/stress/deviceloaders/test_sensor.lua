-- Toroco deviceloader to test signaling

local M = {}

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function (conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

	local devicename='test_sensor'

    local update = {} --event
	
	local device = {}
	
	--- Name of the device
	device.name = devicename

	--- Module name
	device.module = 'test_sensor'

    conf = conf or  {}
	local ip = conf.ip or '*'
	local port = conf.port or 2113
		

    local udp = selector.new_udp (nil, nil, ip, port, 'line')

	--listen for messages
	sched.sigrun ({udp.events.data}, function (_, msg) 

		local cmd, num = nil, nil

		if msg then

            -- get color position
			cmd, num = msg:match ('^([^,]+),([^,]+)$')

            --num = tonumber (num)
		end
		
        sched.signal (update, cmd, num)
		
        return true
	end)

	--- Events emitted by this device.
	-- @table events
	-- @field update Camera data received.
	device.events={
        update = update
	}

	
	toribio.add_device(device)
end

return M
