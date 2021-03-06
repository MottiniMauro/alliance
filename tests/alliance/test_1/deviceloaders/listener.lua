local robot_count = tonumber(os.getenv("ROBOT_COUNT"))
local robot_id = tonumber(os.getenv("ROBOT_ID"))
local starting_port = 5000 --tonumber(os.getenv("STARTING_PORT"))

local socket = require 'socket'
local json = require "json"

local host = "127.0.0.1"
local socket = require("socket")
local robot_ports = {}

local udp = socket.udp()
udp:setsockname("*", starting_port + robot_id)
udp:settimeout(1)

for i = 1, robot_count do
    if i ~= robot_id then
        robot_ports[#robot_ports + 1] = starting_port + i
    end
end

local M = {}

M.init = function(conf)
    local toribio = require 'toribio'
    local devicename = 'listener'
    local device={}

    device.name = 'listener'
    device.module = 'listener'
    device.events = {}

    device.send_updates = function(behavior_name)
		for i = 1, #robot_ports do
            -- print('Sending: ' .. tostring(robot_id) .. ',' .. behavior_name .. " to " .. tostring(robot_ports[i]))
            udp:sendto(tostring(robot_id) .. ',' .. behavior_name, '127.0.0.1', robot_ports[i])
        end
    end

    device.recive_updates = function(...)
        message = udp:receive()
        if message then
            -- print('Received: ' .. message)
            return message
        end
    end  

    toribio.add_device(device)
end

return M