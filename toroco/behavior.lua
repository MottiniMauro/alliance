local M = {}

local toroco = require 'toroco.toroco'
local log = require 'lumen.log'

local meta1, meta2, meta3
meta3 = {
	__index = function (table, key)
		table = setmetatable(table, {})
        table.name = key

        local behavior = toroco.wait_for_behavior (table.emitter)             

        if not behavior.events or not behavior.events[table.name] then 
            log ('TOROCO', 'WARN', 'Event not found for behavior %s: "%s"', tostring(behavior), tostring(table.name))
        end

        table.signal = behavior.events[table.name]

		return table
	end,
}
meta2 = {
	__index = function (table, key)
        if key == 'event' then
		    return setmetatable(table, meta3)
        else
            return nil
        end
	end,
}
meta1 = {
	__index = function (table, key)
		return setmetatable({ type = 'behavior', emitter = key}, meta2)
	end,
}
setmetatable(M, meta1)

return M
