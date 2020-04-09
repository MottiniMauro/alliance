-- Toroco actuator to test latency

local M = {}

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function (conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

	local devicename='test_actuator'

    local update = {} --event
	
	local time_max = 0
	local time_avg = 0
	local time_min = 999
	local time_cant = 0
	
	-- device
	local device = {}
	
	--- Name of the device
	device.name = devicename

	--- Module name
	device.module = 'test_actuator'

    conf = conf or  {}
	local ip = conf.ip or '*'
	local port = conf.port or 2120
		

    local udp = selector.new_udp (ip, port, nil, nil, -1)

	--- Events emitted by this device.
	-- @table events
	device.events={
	}

	-- function that sends the packet to the receiver

    device.send = function (start_time, cmd, num, total_start_time)
    
    	-- get time gap
    	local trc_time = sched.get_time() - start_time
    	
    	-- update max and min values
    	if trc_time > time_max then
    		time_max = trc_time
    	end
    	if trc_time < time_min then
    		time_min = trc_time
    	end
    	
    	-- update avg and cant
    	time_avg = time_avg + trc_time
    	time_cant = time_cant + 1
    	
    	if cmd == 'end' then
    	
    		-- print results
    		print ("Max latency time", math.floor (1000000 * time_max), "us")
    		print ("Avg latency time", math.floor (1000000 * time_avg / time_cant), "us")
    		print ("Min latency time", math.floor (1000000 * time_min), "us")
			
			if total_start_time then
    			local total_time = sched.get_time() - total_start_time
    			print ("Elapsed time", math.floor (1000000 * total_time), "us")
    			
    			print ("Avg interval", math.floor (1000000 * total_time / time_cant), "us")
    		end
    		
    		--reset values
			time_max = 0
			time_avg = 0
			time_min = 999
			time_cant = 0
    	end
    
		udp:send_sync(cmd..','..num..'\n')
	end

	toribio.add_device(device)
end

return M
