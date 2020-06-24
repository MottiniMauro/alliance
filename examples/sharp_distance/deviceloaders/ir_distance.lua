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
		print('Initializing IR distance sensor '.. v[1] .. ' on Port ' .. v[2] .. ' triggering at ' .. v[3])	
		local device={}
		
		local trigger_event={}
		device.name=v[1]
		device.module='sharp'
		device.events={
			triggered=trigger_event
		}

		local dir = '/home/robot/sharp/' .. v[1] ..'/'
		os.execute('mkdir -p '.. dir)
		local f = io.open(dir .. 'signal', 'w')
                f:write('-')
                f:close()
		
		local controller_file = io.popen('find /home/robot/ -name "sharp_controller.py"')
		
		os.execute('python ' ..controller_file:read() .. ' '  .. v[1] .. ' ' .. v[2] .. ' 2Y0A02 ' .. v[4] ..' &')
		--print(python_pid:read())
		--print(python_id)
		
		local filename = dir .. 'value'
		print ('Opening file ' .. filename)
		local val = 0
		device.task = sched.run(function()			
			while true do
				file = io.open(filename, "r")
				local buff = nil
				--file does not exist untill python is running
				if file then
					buff = tonumber(file:read())
					file:close()
				end
				
				if buff then
					if buff < v[3] or v[3] == 0 then
						val = buff		
						sched.signal( device.events.triggered, buff)
					end
--					print(buff)
					sched.sleep( 1.0/v[4]  )
				end
				local f = io.open(dir..'signal', 'w')
                                f:write('-')
                                f:close()
			end
		end)
	
		device.get_value = function ()
			return val
		end
		
		device.set_pause = function ( pause )
			device.task:set_pause( pause )
		end
		
		toribio.add_device( device )
	end
end

return M
