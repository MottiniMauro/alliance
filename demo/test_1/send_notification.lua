robot_id = tonumber(os.getenv("ROBOT_ID"))
starting_port = 5000 --tonumber(os.getenv("STARTING_PORT"))

socket = require 'socket'
json = require "json"

host = "127.0.0.1"
socket = require("socket")
robot_ports = {}

udp = socket.udp()
udp:setsockname("*", starting_port + robot_id)
udp:settimeout(1)

udp:sendto(tostring(robot_id) .. ',' .. behavior_name, '127.0.0.1', robot_ports[1])