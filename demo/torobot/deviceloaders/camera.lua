-- Toroco deviceloader to test signaling

local M = {}

local function split(str, sep)
    sep = sep or ','
    fields={}
    local matchfunc = string.gmatch(str, "([^"..sep.."]+)")
    if not matchfunc then return {str} end
    for str in matchfunc do
        table.insert(fields, tonumber(str) or str)
    end
    return fields
end

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function (conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

	local devicename='camera'

    local update = {} --event
	
	local device = {}
	
	--- Name of the device (in this case, 'mice').
	device.name = devicename

	--- Module name (in this case, 'mice').
	device.module = 'camera'

    conf = conf or  {}
	local ip = conf.ip or '127.0.0.1'
	local port = conf.port or 2113
		

    local udp = selector.new_udp (nil, nil, ip, port, -1)

	--listen for messages
	sched.sigrun ({udp.events.data}, function (_, msg) 

		local color_x, color_y

		if msg then

            -- get color position
			color_x, color_y = msg:match ('^([^,]+),([^,]+)$')

            color_x = tonumber (color_x)
            color_y = tonumber (color_y)

            -- if out of range, return nil

            if color_x and color_x < -100 then
			    color_x, color_y = nil, nil
            end
		else
			color_x, color_y = nil, nil
		end
		
        sched.signal (update, color_x, color_y)
		
        return true
	end)

	--- Events emitted by this device.
	-- @table events
	-- @field update Camera data received.
	device.events={
        update = update
	}

	
	toribio.add_device(device)
end

return M

