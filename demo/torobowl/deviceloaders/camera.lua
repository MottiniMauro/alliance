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

    local update_red = {} --event for red object
    local update_trq = {} --event for turquoise object
	
	local device = {}
	
	--- Name of the device (in this case, 'mice').
	device.name = devicename

	--- Module name (in this case, 'mice').
	device.module = 'camera'

    conf = conf or  {}
	local ip = conf.ip or '127.0.0.1'
	local port = conf.port or 2113
		

    local udp = selector.new_udp (nil, nil, ip, port, -1)


	local color_hue, color_x, color_y
		
	--listen for messages
	sched.sigrun ({udp.events.data}, function (_, msg)

		if msg then
		
			--print ('msg', msg) 

            -- get color position
			color_hue, color_x, color_y = msg:match ('^([^,]+),([^,]+),([^,]+)$')

            color_x = tonumber (color_x)
            color_y = tonumber (color_y)

            -- if out of range, return nil

            if color_x and color_x < -100 then
			    color_x, color_y = nil, nil
            end
        	
        	if color_hue == 'red' then
        		--print ('cam red', color_x)
        		sched.signal (update_red, color_x, color_y)
        		
        	else
        		--print ('cam trq', color_x)
        		sched.signal (update_trq, color_x, color_y)
        	end
		end
		
        return true
	end)

	--- Events emitted by this device.
	-- @table events
	-- @field update_red Camera data received for a red object.
	-- @field update_trq Camera data received for a turquoise object.
	device.events={
        update_red = update_red,
        update_trq = update_trq
	}

	
	toribio.add_device(device)
end

return M

