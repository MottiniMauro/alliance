--- Library for accesing a mouse.
-- This library allows to read data from a mouse,
-- such as it's coordinates and button presses.
-- The device will be named "mice", module "mice". 
-- @module mice
-- @alias device

local M = {}

--- Initialize and starts the module.
-- This is called automatically by toribio if the _load_ attribute for the module in the configuration file is set to
-- true.
-- @param conf the configuration table (see @{conf}).
M.init = function(conf)
	local toribio = require 'toribio'
	local sched = require 'lumen.sched'
	-- local sensor=toribio.wait_for_device(sensorname)
	for _, v in pairs( conf.sensors) do
		print('Initializing compass sensor '.. v[1] .. ' on Port ' .. v[2] .. ' triggering at ' .. v[3])	
		local device={}
		
		local trigger_event={}
		device.name=v[1]
		device.module='compass'
		device.events={
			triggered=trigger_event
		}
		
		local sensor_number = nil
		
		local p = io.popen('find /sys/class/lego-sensor/sensor*')    
	   	for file in p:lines() do
			if io.open(file .. "/mode"):read() == 'COMPASS' and 
			    tonumber(string.sub(string.match(io.open(file .. "/address"):read(),'in.'), -1)) == v[2] then
				local l = -3
                                while sensor_number == nil do
                                        sensor_number = tonumber(string.sub(file, l))
                                        l = l+1
                                end
			end
	   	end
		
		local filename = '/sys/class/lego-sensor/sensor'.. sensor_number ..'/value0'
		local val = 0
		device.task = sched.run(function()
			-- local f = io.popen("stat -c %Y " + filename)
			-- local last_modified = f:read()
			
			while true do
				file = io.open(filename, "r")
				local buff = tonumber(file:read())
				if buff > v[3] or v[3] == 0 then
					val = buff		
					sched.signal( device.events.triggered, buff)
				end
				--print(buff)
				file:close()
				sched.sleep( 1.0/v[4]  )
			end
		end)
	
		device.get_value = function ()
			return prevState
		end
		
		device.set_pause = function ( pause )
			device.task:set_pause( pause )
		end
		
		toribio.add_device( device )
	end
end

return M
