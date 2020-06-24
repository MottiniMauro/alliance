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
	for _, v in pairs( conf.motors) do
		print('Initializing tacho-motor '.. v[1] .. ' on Port ' .. v[2])	
		local device={}
		device.name=v[1]
		device.module='motor'
		device.events={
		}		
		
		local motor_number = nil

                local p = io.popen('find /sys/class/tacho-motor/motor*')
                for file in p:lines() do
--			print (file)
                        if string.sub(io.open(file .. "/address"):read(), -1) == v[2] then
--				print('found the address')
                		local l = -3                
				while motor_number == nil do
					motor_number = tonumber(string.sub(file, l))
					l = l+1
				end
                        end
                end
--		print(motor_number)

                local base_dir = '/sys/class/tacho-motor/motor'.. motor_number
	
		commands = {}
		for substring in io.open(base_dir .. '/commands' , 'r'):read():gmatch("%S+") do
   			commands[substring] = true
			-- print ( substring )
		end
		
		stop_actions = {}
                for substring in io.open(base_dir .. '/stop_actions' , 'r'):read():gmatch("%S+") do
                        stop_actions[substring] = true
                        -- print ( substring )
                end

		local max_speed = tonumber(io.open(base_dir .. '/max_speed', 'r'):read())

		device.set_speed = function ( speed )
			local f = io.open(base_dir .. '/speed_sp', 'w')
			local sp = math.min(speed, max_speed)
                        f:write(sp)
                        f:close()
		end

		device.reset = function () device.send_command('reset') end

		device.get_position = function () 
			return tonumber(io.open(base_dir .. '/position', 'r'):read())
		end

		device.set_position_sp = function ( pos )
			local f = io.open(base_dir .. '/position_sp', 'w')
                        f:write(pos)
                        f:close() 
		end

		device.move_to_rel_pos = function ( params )
			rel_pos = params[1]
			speed = params[2]
			if speed then device.set_speed(speed) end 
			if rel_pos then device.set_position_sp (rel_pos) end
			device.send_command ('run-to-rel-pos')
		end

		device.move_to_abs_pos = function ( params )
			abs_pos = params[1]
			speed = params[2]			 
			if speed then device.set_speed(speed) end
			if abs_pos then device.set_position_sp (abs_pos) end
			device.send_command ('run-to-abs-pos')
		end

		device.move = function ( speed )
			if speed then device.set_speed(speed) end
			device.send_command('run-forever')
		end

		device.move_timed = function ( params )
			time = params[1]
			speed = params[2]
			if speed then device.set_speed(speed) end
			if time then device.set_time( time ) end
			device.send_command( 'run-timed' )
		end

		device.reset_pos = function () 
			local f = io.open(base_dir .. '/position', 'w')
                        f:write(0)
                        f:close()
                end

		device.set_time = function ( time ) 
			local f = io.open(base_dir .. '/time_sp', 'w')
                        f:write(time)
                        f:close()
                end
		
		device.set_stop_action = function (action)
			if stop_actions[action] == nil then
                                error("Stop action not suported, use the get_stop_actions function to read all suported stop actions")
                        end

                        local f = io.open(base_dir .. '/stop_action', 'w')
                        f:write(action)
                        f:close()
		end

		device.get_stop_actions = function ()
                        return stop_actions
                end

		device.stop = function () device.send_command ( 'stop' ) end

		device.send_command = function ( command )
			print ('Sending command ' .. command ..' to motor') 
			if commands[command] == nil then
				error("Command not suported, use the get_commands function to read all suported commands")
			end

                       	local f = io.open(base_dir .. '/command', 'w')
                        f:write(command)
                        f:close()
                end

		device.get_commands = function () 
			return commands
		end

		device.set_pause = function ( pause )
			device.stop()
			device.task:set_pause( pause )
		end
		
		toribio.add_device( device )
	end
end

return M
