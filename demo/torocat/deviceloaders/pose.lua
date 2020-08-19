local robot_id = tonumber(os.getenv("ROBOT_ID"))

local socket = require 'socket'
local json = require "json"

local host, pose_port = "localhost", 60001 + (4 * (robot_id - 1))
local socket = require("socket")
local pose_tcp = assert(socket.tcp())

pose_tcp:connect(host, pose_port);

print('Pose port ' .. pose_port)

local M = {}

M.init = function(conf)
	local toribio = require 'toribio'
	local devicename = 'pose'
    local device={}

    device.name = 'pose'
    device.module = 'pose'
    device.events = {}

    device.get_value = function(...)
		local pose_message, err = pose_tcp:receive()
	    return pose_message
    end

    toribio.add_device(device)
end

return M