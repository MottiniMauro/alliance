--- DeviceLoader for the mindsensors NXTCam-V3

local M = {}

--- Initialize and starts the module.
-- This is called automatically by toribio if the _load_ attribute for the module in the configuration file is set to
-- true.
-- @param conf the configuration table (see @{conf}).
M.init = function(conf)
	local toribio = require 'toribio'
	local sched = require 'lumen.sched'

	for _, v in pairs( conf.sensors) do
		print('Initializing camera '.. v[1] .. ' on Port ' .. v[2])	
		local device={}
		
		local update_event={}
		device.name=v[1]
		device.module='camera'
		device.events={
			update=update_event
		}
		
		local sensor_number = nil
		
		local p = io.popen('find /sys/class/lego-sensor/sensor*')    
	   	for file in p:lines() do
			if io.open(file .. "/mode"):read() == 'TRACK' and 
			    tonumber(string.sub(string.match(io.open(file .. "/address"):read(),'in.'), -1)) == v[2] then
				local l = -3
                                while sensor_number == nil do
                                        sensor_number = tonumber(string.sub(file, l))
                                        l = l+1
                                end
			end
	   	end

		local sensor_folder = '/sys/class/lego-sensor/sensor'.. sensor_number
		
		-- Send command to start tracking
		local comm_file = io.open(sensor_folder .. '/command', 'w')
                comm_file:write('TRACK-ON')
                comm_file:close()


		local file_prefix = sensor_folder .. '/value'

		device.task = sched.run(function()
			
			while true do
				file = io.open(file_prefix .. '0', "r")
				local object_count = tonumber(file:read())
				file:close()

				file = io.open(file_prefix .. '1', "r")
                                local color_index = tonumber(file:read())
                                file:close()

				file = io.open(file_prefix .. '2', "r")
                                local x_ul = tonumber(file:read())
                                file:close()

				file = io.open(file_prefix .. '3', "r")
                                local y_ul = tonumber(file:read())
                                file:close()

				file = io.open(file_prefix .. '4', "r")
                                local x_lr = tonumber(file:read())
                                file:close()

				file = io.open(file_prefix .. '5', "r")
                                local y_lr = tonumber(file:read())
                                file:close()

				sched.signal( device.events.update, object_count, color_index, x_ul, y_ul, x_lr, x_lr)
				
				--print(buff)
				
				sched.sleep( 1.0/v[3]  )
			end
		end)
		
		device.set_pause = function ( pause )
			device.task:set_pause( pause )
		end
		
		toribio.add_device( device )
	end
end

return M
