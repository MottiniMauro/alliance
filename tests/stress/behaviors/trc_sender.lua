-- /// trc_sender ///

local toroco = require 'toroco.toroco'
local sched = require 'lumen.sched'

-- /// Functions ///

local coroutine1 = function ()
	
	local total_start_time = sched.get_time()

	local start_time

	-- send 999 events
	for indx = 1, 1000 do
	
		start_time = sched.get_time()
		
    	toroco.send_output {ping = {start_time, "hello", indx}}
    	
    	sched.sleep (0.01)
	end

	-- send last event
	start_time = sched.get_time()
    toroco.send_output {ping = {start_time, "end", 1000, total_start_time}}
    
end

return coroutine1



