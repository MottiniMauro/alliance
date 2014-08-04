local M = {}

local toroco = require 'toroco.toroco'
local log = require 'lumen.log'

local meta1, meta2
meta2 = {
	__index = function (table, key)
		table = setmetatable(table, {})
        table.name = key

		return table
	end,
}
meta1 = {
	__index = function (table, key)
		return setmetatable({ type = 'behavior', emitter = key}, meta2)
	end,
}
setmetatable(M, meta1)

return M
