-- Toroco deviceloader to test signaling

local M = {}

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function (conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

	local devicename='test_actuator'

    local update = {} --event
	
	local device = {}
	
	--- Name of the device
	device.name = devicename

	--- Module name
	device.module = 'test_actuator'

    conf = conf or  {}
	local ip = conf.ip or '*'
	local port = conf.port or 2113
		

    local udp = selector.new_udp (ip, port, nil, nil, -1)

	--- Events emitted by this device.
	-- @table events
	device.events={
	}

    device.send=function(...)
		udp:send_sync(...)
	end

	toribio.add_device(device)
end

return M
