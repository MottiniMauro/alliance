-- Toroco sensor to test latency

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
	local port = conf.port or 2120
		

    local udp = selector.new_udp (nil, nil, ip, port, 'line')

	--listen for packets
	
	sched.sigrun ({udp.events.data}, function (_, msg) 

    	local trc_time = sched.get_time()
    	
		local cmd, num = nil, nil

		if msg then

            -- get color position
			cmd, num = msg:match ('^([^,]+),([^,]+)$')

            --num = tonumber (num)
		end
		
        sched.signal (update, trc_time, cmd, num)
		
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
