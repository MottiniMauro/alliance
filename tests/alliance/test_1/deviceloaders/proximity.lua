local socket = require 'socket'

local host, port = "localhost", 60001
local socket = require("socket")

local tcp = assert(socket.tcp())

tcp:connect(host, port);
tcp:settimeout(0.5)

print('Proximity port: ' .. port)

local M = {}

M.init = function(conf)
    local toribio = require 'toribio'
    local devicename = 'proximity'
    local device={}

    device.name = 'proximity'
    device.module = 'proximity'
    device.events = {}

    device.get_value = function(...)
        local message, err = tcp:receive()
        print(message)
        return message
    end

    toribio.add_device(device)
end

return M