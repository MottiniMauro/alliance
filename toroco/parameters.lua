local M = {}

local meta1
meta1 = {
	__index = function (table, key)
		return { type = 'input', name = key }
	end,
}
setmetatable(M, meta1)

return M
