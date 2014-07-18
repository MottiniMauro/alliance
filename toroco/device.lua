local M = {}

local toribio = require 'toribio'
local log = require 'lumen.log'

local meta1, meta2, meta3
meta3 = {
	__index = function (table, key)
		table = setmetatable(table, {})
        table.name = key
        
        local device = toribio.wait_for_device ({ module = table.emitter })             

        if not device.events or not device.events[table.name] then 
            log ('TORIBIO', 'WARN', 'Event not found for device %s: "%s"', tostring(device), tostring(table.name))
        end

        table.signal = device.events[table.name]

		return table
	end,
}
meta2 = {
	__index = function (table, key)
        if key == 'event' then
		    return setmetatable(table, meta3)
        else
            table = setmetatable(table, {})
            local meta_call_device = {
                __call = function(table, ...)
                    local device = toribio.wait_for_device ({ module = table.emitter }) 
                    device[key](...)
                end
            }

            return setmetatable(table, meta_call_device)
        end
	end,
}
meta1 = {
	__index = function (table, key)
		return setmetatable({ type = 'device', emitter = key}, meta2)
	end,
}
setmetatable(M, meta1)

return M
