local M = {}

local meta1
meta1 = {
	__index = function (table, key)
		return { type = 'output', name = key }
	end,
}
setmetatable(M, meta1)

return M
