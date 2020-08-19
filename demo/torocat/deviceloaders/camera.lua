local robot_id = tonumber(os.getenv("ROBOT_ID"))

local socket = require 'socket'
local json = require "json"

local host, left_cam_port, right_cam_port = "localhost", 60002 + (4 * (robot_id - 1)), 60003 + (4 * (robot_id - 1))
local socket = require("socket")

local left_cam_tcp = assert(socket.tcp())
local right_cam_tcp = assert(socket.tcp())

left_cam_tcp:connect(host, left_cam_port);
right_cam_tcp:connect(host, right_cam_port);

print('Camera ports ' .. left_cam_port .. ' ' .. right_cam_port)

local M = {}

M.init = function(conf)
	local toribio = require 'toribio'
	local devicename = 'camera'
    local device={}

    device.name = 'camera'
    device.module = 'camera'
    device.events = {}

    device.get_value = function(...)
		local left_message, err = left_cam_tcp:receive()
		local right_message, err = right_cam_tcp:receive()

	    return {left_message, right_message}
    end

    toribio.add_device(device)
end

return M