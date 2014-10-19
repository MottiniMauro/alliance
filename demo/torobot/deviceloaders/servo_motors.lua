-- Toroco deviceloader to test signaling

local M = {}

local run_shell = function(s)
	local f = io.popen(s) -- runs command
	local l = f:read("*a") -- read output of command
	f:close()
	return l
end

--- Initialize and starts the module.
-- @param conf the configuration table (see @{conf}).
M.init = function(conf)
	local toribio = require 'toribio'
	local selector = require 'lumen.tasks.selector'
	local sched = require 'lumen.sched'

    -- loads am33xx_pwm module
    run_shell('echo am33xx_pwm > /sys/devices/bone_capemgr.9/slots')

    -- enables pwm for servo motor control pins
    run_shell('echo bone_pwm_P9_14 > /sys/devices/bone_capemgr.9/slots')
    run_shell('echo bone_pwm_P9_22 > /sys/devices/bone_capemgr.9/slots')

    sched.sleep(1)

    -- set pwm period and polarity
    run_shell('echo 20000000 > /sys/devices/ocp.3/pwm_test_P9_22.16/period')
    run_shell('echo 20000000 > /sys/devices/ocp.3/pwm_test_P9_14.15/period')
    run_shell('echo 0 > /sys/devices/ocp.3/pwm_test_P9_22.16/polarity')
    run_shell('echo 0 > /sys/devices/ocp.3/pwm_test_P9_14.15/polarity')

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
    -- @vel must be between -100 and +100
	device.setvel2mtr=function(vel1, vel2)
        run_shell('echo '.. 1460000 - vel1*2000 ..' > /sys/devices/ocp.3/pwm_test_P9_14.15/duty')
        run_shell('echo '.. 1460000 + vel2*2000 ..' > /sys/devices/ocp.3/pwm_test_P9_22.16/duty')
	end
	
	toribio.add_device(device)
end

return M

