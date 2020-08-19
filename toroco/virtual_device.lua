local M = {}

local meta1, meta2

meta2 = {
	__index = function (table, key)
        table = setmetatable(table, {})
        local meta_call_virtual_device = {
            __call = function(table, ...)
                local virtual_device = toribio.wait_for_virtual_device ({ module = table.emitter }) 
                virtual_device[key](...)
            end
        }
        table.name = key

        return setmetatable(table, meta_call_virtual_device)
	end,
}
meta1 = {
	__index = function (table, key)
		return setmetatable({ type = 'virtual_device', emitter = key}, meta2)
	end,
}
setmetatable(M, meta1)

return M
