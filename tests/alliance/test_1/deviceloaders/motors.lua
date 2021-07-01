local robot_id = tonumber(os.getenv("ROBOT_ID"))

local socket = require 'socket'

local host, commands_port = "localhost", (4000 + robot_id - 1)
local socket = require("socket")
local commands_tcp = assert(socket.tcp())

commands_tcp:connect(host, commands_port);

local M = {}

print('Commands port ' .. commands_port)

M.init = function(conf)
	local toribio = require 'toribio'
	local device={}
	
	device.name='motors'
	device.module='motors'
	device.events={}

	device.setvel2mtr=function(speed)
		speed1 = speed[1]
		speed2 = speed[2]
		local command = 'id1 collector' .. robot_id .. '.motion' .. robot_id ..  ' set_speed [' .. speed1.. ', ' .. speed2 .."]\n"
	    commands_tcp:send(command);
	end

	toribio.add_device(device)
end

return M

