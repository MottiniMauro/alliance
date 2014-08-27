-- Toroco deviceloader to test polling.
-- This device returns true or false.
-- The returned data is the status of left/ight mouse buttons.

local M = {}

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function(conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

    for _, event in ipairs({'left', 'right'}) do
	    local devicename = 'trc_grey_'..event
	
	    local device={}

        local value = false
	
	    --- Name of the device (in this case, 'mice').
	    device.name = devicename

	    --- Module name (in this case, 'mice').
	    device.module = 'trc_grey'


	    --- Events emitted by this device.
	    -- @table events
	    device.events = {
	    }

        -- capture the mouse button signals
	    local mice = toribio.wait_for_device ({module='mice'})
	
        -- register the callback for the mouse event
        -- to get the grey value.
	    toribio.register_callback (mice, event..'button', function(v)
		    value = v
	    end)

	    --- public function that returns the grey value
	    device.get_value = function(...)
		    return value
	    end
	
	
	    toribio.add_device(device)
    end
end

return M

