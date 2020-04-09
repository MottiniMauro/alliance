-- Toroco deviceloader to test signaling

local M = {}

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function(conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

    local file = assert(selector.new_fd('/sys/devices/bone_capemgr.9/slots', {'wronly', 'sync'}, nil)

    file:write('am33xx_pwm')
    file:write('bone_pwm_P9_14')
    file:write('bone_pwm_P9_22')

    file:close()

    local period = assert(selector.new_fd('/sys/devices/ocp.3/pwm_test_P9_22.16/period', {'wronly', 'sync'}, nil)
    period:write('20000000')
    period:close()

    period = assert(selector.new_fd('/sys/devices/ocp.3/pwm_test_P9_14.15/period', {'wronly', 'sync'}, nil)
    period:write('20000000')
    period:close()

    local polarity = assert(selector.new_fd('/sys/devices/ocp.3/pwm_test_P9_22.16/polarity', {'wronly', 'sync'}, nil)
    polarity:write('0')
    polarity:close()

    polarity = assert(selector.new_fd('/sys/devices/ocp.3/pwm_test_P9_14.15/polarity', {'wronly', 'sync'}, nil)
    polarity:write('0')
    polarity:close()

    local left_motor_duty = assert(selector.new_fd('/sys/devices/ocp.3/pwm_test_P9_22.16/duty', {'wronly', 'sync'}, nil)
    local right_motor_duty = assert(selector.new_fd('/sys/devices/ocp.3/pwm_test_P9_14.15/duty', {'wronly', 'sync'}, nil)

	local devicename='servo_motors'
	
	local device={}
	
	--- Name of the device (in this case, 'mice').
	device.name=devicename

	--- Module name (in this case, 'mice').
	device.module='servo_motors'


	--- Events emitted by this device.
	-- @table events
	device.events={
	}

	--- Prints the values passed
	device.setvel2mtr=function(dir1, vel1, dir2, vel2)
		left_motor_duty:write (1460000 + dir1*vel1*1000)
		right_motor_duty:write (1460000 + dir2*vel2*1000)
	end
	
	toribio.add_device(device)
end

return M

