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
		print('Initializing touch sensor '.. v[1] .. ' on Port ' .. v[2])	
		local device={}
		local pressed_event={}
		local released_event={}
		local changed_event={}
		device.name=v[1]
		device.module='button'
		device.events={
			pressed=pressed_event,
			released=released_event,
			changed=changed_event
		}
		
		
		local sensor_number = nil

                local p = io.popen('find /sys/class/lego-sensor/sensor*')
                for file in p:lines() do
                        if io.open(file .. "/mode"):read() == 'TOUCH' and tonumber(string.sub(io.open(file .. "/address"):read(), -1)) == v[2] then
                		local l = -3                
				while sensor_number == nil do
					sensor_number = tonumber(string.sub(file, l))
					l = l+1
				end
                        end
                end
		print(sensor_number)

                local filename = '/sys/class/lego-sensor/sensor'.. sensor_number ..'/value0'
	
		device.task = sched.run(function()
			-- local f = io.popen("stat -c %Y " + filename)
			-- local last_modified = f:read()
			local prevState = ''
			while true do
				file = io.open(filename, "r")
				local buff = file:read()
				if buff ~= prevState then
					if buff == '1' then
						sched.signal( device.events.pressed )
						-- print("pressed")
					else
						sched.signal( device.events.released )
					end
					sched.signal( device.events.changed, buff)
					prevState = buff
				end
				--print(buff)
				file:close()
				sched.sleep( 1.0/v[3]  )
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
