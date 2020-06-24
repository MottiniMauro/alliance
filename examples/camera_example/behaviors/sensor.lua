-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local input = toroco.input

-- /// functions ///

local sensor_handler = function(event, c)
	-- Obj_count, col_index, x_ul, y_ul, x_lr, y_lr
	print ( c[1], c[2], c[3], c[4], c[5], c[6] )
end


return toroco.trigger (input.update, sensor_handler)
