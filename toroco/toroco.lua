package.path = package.path .. ";;;lumen/?.lua;toribio/?/init.lua;toribio/?.lua"

local M = {}

-- ****************
-- *** Requires ***
-- ****************

local toribio = require 'toribio'
local sched = require 'lumen.sched'
local mutex = require 'lumen.mutex'
local log = require 'lumen.log'

M.input = require 'toroco.input'
M.output = require 'toroco.output'
M.device = require 'toroco.device'
M.behavior = require 'toroco.behavior'

require 'lumen.tasks.selector'.init({service='nixio'})

-- *****************
-- *** Variables ***
-- *****************

-- Behaviors managed by Torocó

M.behaviors = {}

M.behavior_taskd = {}

local events = {
	new_behavior = {}
}
M.events = events

local polling_devices = {}

-- List of registered receivers for each event

local registered_receivers = {}
local inhibited_events = {}

-- *****************
-- *** Functions ***
-- *****************

-- This function is executed when Torocó captures a signal.
-- It resend the signal to all receivers which registered to the event,
-- applying the inhibition and suppression restrictions.

local dispatch_signal = function (event, ...)

    registered_receivers [event].mutex:acquire()

    -- update inhibition
    for inhibitor, inhibition in pairs (inhibited_events [event]) do

        if inhibition.expire_time and inhibition.expire_time < sched.get_time() then
            inhibited_events [event] [inhibitor] = nil
        end
    end

    -- check inhibition
    if next(inhibited_events [event]) == nil then

        -- for each registered receiver of the event, ...
        for key, receiver in ipairs (registered_receivers [event]) do

            -- update inhibition
            for inhibitor, inhibition in pairs(receiver.inhibited) do
                if inhibition.expire_time and inhibition.expire_time < sched.get_time() then
                    receiver.inhibited [inhibitor] = nil
                end
            end

            -- check inhibition
            if next(receiver.inhibited) == nil then

                -- send alias signal
                sched.signal (receiver.event_alias, ...)

                if receiver.execute_once then
                    table.remove(registered_receivers [event], key)
                end
            end
        end 
    end

    registered_receivers [event].mutex:release()
end

-- Torocó version of sched.wait_for_device().

local my_wait_for_device = function(devdesc, timeout)
	assert(sched.running_task, 'Must run in a task')
	
	local wait_until
	if timeout then wait_until=sched.get_time() + timeout end
	
	local device_in_devices
	
	device_in_devices = function (dd)
        if toribio.devices[dd] then
            return toribio.devices[dd]
        else
		    for _, device in pairs(toribio.devices) do
			    if device.module == dd then 
                    return device 
                end
		    end
        end
	end

	local in_devices=device_in_devices(devdesc)
	if in_devices then 
		return in_devices
	else
		local tortask = toribio.task
		local waitd = {toribio.events.new_device}
		if wait_until then waitd.timeout=wait_until-sched.get_time() end
		while true do
			local ev, device = sched.wait(waitd) 
			if not ev then --timeout
				return nil, 'timeout'
			end
			if device.name == devdesc or device.module == devdesc then
				return device 
			end
			if wait_until then waitd.timeout=wait_until-sched.get_time() end
		end
	end
	
end

-- returns the real event from a device or behavior.
-- event_desc: event descriptor (return value of /toroco/device or /toroco/behavior)

local get_real_event = function (event_desc)

	-- if the event is defined in a device, ...

    if event_desc.type == 'device' then
        
        local wait_for_device = my_wait_for_device
        if type (event_desc.emitter) == 'table' then
            wait_for_device = toribio.wait_for_device
        end

        local device = wait_for_device (event_desc.emitter)
        
        -- if the device does not have the event, ...
        if not device.events or not device.events[event_desc.name] then
        
        	-- if the device has a function with that event, ...
            if device[event_desc.name] then
            	
            	-- return the event of the device polling function
                if polling_devices[event_desc.emitter] and polling_devices[event_desc.emitter][event_desc.name] then

                    return polling_devices[event_desc.emitter][event_desc.name].event
                
                -- create a new device polling function, and return the new event
                else
                	-- polling event
                    local event = {}

                    -- polling function
                    local value = nil
                    local polling_function = function()
                        local new_value = device[event_desc.name]();

                        if (new_value ~= value) then
                            value = new_value
                            sched.signal (event, new_value)
                        end
                    end

					-- store the polling event in polling_devices.
                    if not polling_devices[event_desc.emitter] then
                        polling_devices[event_desc.emitter] = {}
                    end
                    polling_devices[event_desc.emitter][event_desc.name] = { event = event }

					-- start the polling function.
                    sched.sigrun ({ {}, timeout = 0.1 }, polling_function)

                    return event
                end
            else
                log ('TORIBIO', 'WARN', 'Event not found for device %s: "%s"', tostring(device), tostring(event_desc.name))
            end
        end

        -- if the device has the event, return it.
        return device.events[event_desc.name]

	-- if the event is defined in a behavior, ...
    elseif event_desc.type == 'behavior' then 

        local behavior = M.wait_for_behavior (event_desc.emitter)     
       
        if not behavior.events[event_desc.name] then 
            behavior.events[event_desc.name] = {}
            behavior.event_count = behavior.event_count + 1
        end

        return behavior.events[event_desc.name]
    end
end


-- /// Inhibit an event ///
-- This function inhibits an event sent by a behavior.
-- The inhibition is associated with the running behavior,
-- and is independent of other inhibitions to the same event that were set by other behaviors.
-- event_desc: event descriptor (return value of /toroco/device or /toroco/behavior)
-- timeout: number of seconds (optional)

M.inhibit = function(event_desc, timeout)

    local event = get_real_event(event_desc)

    -- if the event is not inhibited for longer than proposed, set the new time.
    -- if the event is inhibited for longer than proposed, do nothing.
    -- if there is no timeout, delete the expire time.

    inhibited_events [event] = inhibited_events [event] or {}

    if timeout then
        if not inhibited_events [event] [M.behavior_taskd [sched.running_task]]
        or not inhibited_events [event] [M.behavior_taskd [sched.running_task]].expire_time 
        or inhibited_events [event] [M.behavior_taskd [sched.running_task]].expire_time < sched.get_time() + timeout then
            inhibited_events [event] [M.behavior_taskd [sched.running_task]] = { expire_time = sched.get_time() + timeout }
        end
    else
        inhibited_events [event] [M.behavior_taskd [sched.running_task]] = { expire_time = nil }
    end
end

-- /// Release an inhibition to an event ///
-- This function releases an inhibition to an event.
-- The released inhibition is the one associated with the running behavior,
-- and is independent of other inhibitions to the same event that were set by other behaviors.
-- event_desc: event descriptor (return value of /toroco/device or /toroco/behavior)

M.release_inhibition = function (event_desc)

    local event = get_real_event (event_desc)

    inhibited_events [event] [M.behavior_taskd [sched.running_task]] = nil
end

-- /// Suppress an event ///
-- This function suppresses an event received by a specific behavior.
-- The suppression is associated with the running behavior,
-- and is independent of other suppressions to the same event that were set by other behaviors.
-- event_desc: event descriptor (return value of /toroco/device or /toroco/behavior)
-- receiver_desc: receiver descriptor (return value of /toroco/behavior)
-- timeout: number of seconds (optional)
-- signal_data: table with data to be sent to the receiver (optional).

M.suppress = function (event_desc, receiver_desc, timeout, signal_data)

    local event = get_real_event(event_desc)

    for _, receiver in ipairs (registered_receivers[event]) do
        if receiver.name == receiver_desc.emitter then

            -- set receiver as inhibited
            receiver.inhibited = receiver.inhibited or {}

            if timeout then
                if not receiver.inhibited [M.behavior_taskd [sched.running_task]]
                or not receiver.inhibited [M.behavior_taskd [sched.running_task]].expire_time 
                or receiver.inhibited [M.behavior_taskd [sched.running_task]].expire_time < sched.get_time() + timeout then
                    receiver.inhibited [M.behavior_taskd [sched.running_task]] = { expire_time = sched.get_time() + timeout }
                end
            else
                receiver.inhibited [M.behavior_taskd [sched.running_task]] = { expire_time = nil }
            end
        end
    end

    -- send signals

    if signal_data then

        for _, receiver in ipairs (registered_receivers[event]) do
            if receiver.name == receiver_desc.emitter then

                sched.signal (receiver.event_alias, unpack (signal_data))
            end
        end
    end

end

-- /// Release a suppression to an event ///
-- This function releases a suppression to an event for a specific behavior.
-- The released suppression is the one associated with the running behavior,
-- and is independent of other inhibitions to the same event that were set by other behaviors.
-- event_desc: event descriptor (return value of /toroco/device or /toroco/behavior)
-- receiver_desc: receiver descriptor (return value of /toroco/behavior)

M.release_suppression = function (event_desc, receiver_desc)

    local event = get_real_event (event_desc)

    if not event then
	    log ('TOROCO', 'ERROR', 'release_suppression(): receiver is not valid. %s %s', section, task)
    end

    for _, receiver in ipairs (registered_receivers[event]) do
        if receiver.name == receiver_desc.emitter then
            receiver.inhibited [M.behavior_taskd [sched.running_task]] = nil;
        end
    end 
end

-- returns the task name.
-- conf: configuration table of the task.

local get_task_name = function(conf)
    local config = toribio.configuration['tasks'] or {}    
    for k, v in pairs(config) do
        if v == conf then
            return k
        end
    end
end

-- Registers the dispatch signal function to an event
-- event: event to be registered.

local register_dispatcher = function(event)

    inhibited_events [event] = inhibited_events [event] or {}

    local waitd = {
        event
    }

    sched.sigrun(waitd, dispatch_signal)
end

-- Stores the task for the event of the inputs in 'registered_receivers',
-- and registers the event aliases for the input.

local register_handler = function(behavior_name, input_source, input_handler)

    local event = get_real_event(input_source)

    -- initialize the callback receiver
    local receiver = {}
    receiver.name = behavior_name
    receiver.event_alias = {}
    receiver.inhibited = {}

    -- add the receiver to registered_receivers
    registered_receivers [event].mutex:acquire()
    table.insert (registered_receivers[event], receiver)
    registered_receivers [event].mutex:release()

    -- initialize the callback function
    local mx = mutex.new()
    local fsynched = mx:synchronize (function(_, ...)
            input_handler(input_source.name, ...)
        end
    )

    local waitd = {
		receiver.event_alias
	}

 	local taskd = sched.new_task( function()
		while true do
			fsynched(sched.wait(waitd))
		end
	end)

    return taskd
end 


local set_device_inputs = function(device_name, input_sources)

    for input_name, input_source in pairs (input_sources) do
        local proxy = function(_, ...)
            local device = my_wait_for_device (device_name) 
            device[input_name](...)
        end

        local register_source = function (input_source)
            -- initialize the dispatcher 
            local event = get_real_event(input_source)

            if not registered_receivers[event] then
                registered_receivers[event] = {mutex = mutex.new()}

                register_dispatcher (event)
            end

            -- registers the (proxy) target function for the event.
            local taskd = register_handler (device_name, input_source, proxy)
            sched.set_pause (taskd, false)
        end

        if input_source.type then
            register_source (input_source)
        else
            for _, source in ipairs(input_source) do
                register_source (source)
            end
        end
    end
end

-- /// Wait for an input ///
-- This function pauses a coroutine or trigger handler 
-- until an input is received.
-- input_desc: input descriptor (return value of /toroco/input)
-- timeout: number of seconds to wait or return nil (optional)

M.wait_for_input = function(input_desc, timeout)

    -- get event
    local input_source = M.behavior_taskd [sched.running_task].input_sources [input_desc.name]
    local event = get_real_event (input_source)

    -- initialize the waiting receiver
    local receiver = {}
    receiver.name = M.behavior_taskd [sched.running_task].name
    receiver.event_alias = {}
    receiver.inhibited = {}
    receiver.execute_once = true

    -- add the receiver to registered_receivers
    registered_receivers [event].mutex:acquire()
    table.insert (registered_receivers [event], receiver)
    registered_receivers [event].mutex:release()

    -- initialize the waiting function
    local waitd = {
		receiver.event_alias,
		timeout = timeout,
	}

    local f = function(_, ...)
        return ...
    end

    return f(sched.wait(waitd)) 
end

-- /// Send the behavior output ///
-- This function sends the output of a behavior, that is,
-- it sends a signal for each output event of the behavior.
-- output_value: table with the extra parameters for each signal.

M.send_output = function(output_values)

    assert(M.behavior_taskd [sched.running_task], 'Must run in a behavior')

	-- for each event of the behavior, ...
    for event_name, event in pairs(M.behavior_taskd [sched.running_task].events) do
    
    	-- send a signal for the event, with the extra parameters
        if output_values[event_name] then
            sched.signal (event, unpack(output_values[event_name]))

    	-- Warning: the event is not defined at the send_output invocation
        else
            sched.signal (event)
            print ('Warning: Missing event ' .. event_name .. ' at send_output() in behavior ' .. M.behavior_taskd [sched.running_task].name .. '.')
        end
    end

    -- check for unused events in output_values
    local count = 0
    for _ in pairs(output_values) do 
        count = count + 1
    end
    if count > M.behavior_taskd [sched.running_task].event_count then
        print ('Warning: Unused events at send_output() in behavior ' .. M.behavior_taskd [sched.running_task].name .. '.')
    end
end

-- add coroutine to a behavior
-- behavior_desc: behavior descriptor (return value of /toroco/behavior)
-- coroutine: function to be executed.

local add_coroutine = function (behavior_name, coroutine) 

    sched.run(function()
        local taskd = sched.new_task(coroutine)

        M.wait_for_behavior(behavior_name)

        M.behavior_taskd [taskd] = M.behaviors[behavior_name]

        table.insert (M.behaviors[behavior_name].tasks, taskd)

        sched.set_pause (taskd, false)
    end)
end

-- /// Set the behavior inputs. ///
-- receiver_desc: receiver descriptor (return value of /toroco/behavior)
-- input_sources: table where the keys are the input names
-- and the values are input descriptors (return value of /toroco/device or /toroco/behavior)

M.set_inputs = function (receiver_desc, input_sources)

    local set_inputs_task = function ()
        if receiver_desc.type == 'behavior' then

            M.behaviors[receiver_desc.emitter].input_sources = input_sources

            -- initialize the dispatchers
            for _, input_source in pairs (input_sources) do
            
                local event = get_real_event (input_source)

                if not registered_receivers[event] then
                    registered_receivers[event] = {mutex = mutex.new()}

                    register_dispatcher (event)
                end
            end
        elseif receiver_desc.type == 'device' then

            set_device_inputs (receiver_desc.emitter, input_sources)
        end
    end

    sched.run(set_inputs_task)
end


-- /// Create a trigger function ///
-- Returns a coroutine that implements the trigger.
-- input_desc: input descriptor (return value of /toroco/input)
-- handler: function to be called when the input is received.

M.trigger = function (input_desc, handler)

    local coroutine = function()
        local behavior =  M.behavior_taskd [sched.running_task]
        local taskd = register_handler (behavior.name, behavior.input_sources[input_desc.name], handler)
            
        M.behavior_taskd [taskd] = M.behaviors[behavior.name]

        table.insert (M.behaviors[behavior.name].tasks, taskd)

        sched.set_pause (taskd, false)
    end    

    return coroutine 
end


-- /// Suspend a behavior ///
-- behavior_desc: behavior descriptor (return value of /toroco/behavior)

M.suspend_behavior = function (behavior_desc)

    local remove_taskd_keys = {}

    for key, taskd in ipairs (M.behaviors [behavior_desc.emitter].tasks) do

        if taskd.status ~= 'dead' then
            sched.set_pause (taskd, true)
        else
            table.insert (remove_taskd_keys, key)
            M.behavior_taskd [taskd] = nil
        end
    end

    for _, key in ipairs (remove_taskd_keys) do
        table.remove (M.behaviors [behavior_desc.emitter].tasks, key)
    end
end


-- /// Resume a behavior ///
-- behavior_desc: behavior descriptor (return value of /toroco/behavior)

M.resume_behavior = function (behavior_desc)

    local remove_taskd_keys = {}

    for key, taskd in ipairs (M.behaviors [behavior_desc.emitter].tasks) do

        if taskd.status ~= 'dead' then
            sched.set_pause (taskd, false)
        else
            table.insert (remove_taskd_keys, key)
            M.behavior_taskd [taskd] = nil
        end
    end

    for _, key in ipairs (remove_taskd_keys) do
        table.remove (M.behaviors [behavior_desc.emitter].tasks, key)
    end
end


-- /// Resume a behavior ///
-- behavior_desc: behavior descriptor (return value of /toroco/behavior)

M.remove_behavior = function (behavior_desc)

    for _, taskd in ipairs (M.behaviors [behavior_desc.emitter].tasks) do
        if taskd.status ~= 'dead' then
            sched.kill (taskd)
        end
        M.behavior_taskd [taskd] = nil
    end

    for event, event_receivers in ipairs (registered_receivers) do
        for _, receiver in ipairs (event_receivers) do
            if receiver.name == behavior_desc.emitter then

                registered_receivers [event] = nil
            end
        end
    end

    for event, event_table in pairs (inhibited_events) do
        event_table [M.behaviors [behavior_desc.emitter]] = nil
    end

    M.behaviors [behavior_desc.emitter] = nil

end


-- suspend a task until the behavior has been registered to Torocó.

M.wait_for_behavior = function(behavior_name, timeout)
    assert(sched.running_task, 'Must run in a task')

    -- if the behavior is already loaded, return success.

    if M.behaviors[behavior_name] and M.behaviors[behavior_name].loaded then
        return M.behaviors[behavior_name]
    end

    -- else, ...

	local wait_until
	if timeout then 
        wait_until = sched.get_time() + timeout 
    end
    
    local waitd = {M.events.new_behavior}
    if wait_until then 
        waitd.timeout = wait_until-sched.get_time() 
    end

    while true do

        -- wait for the event 'new_behavior'
	    local ev, new_behavior_name = sched.wait(waitd) 

        -- process the result.
	    if not ev then --timeout
		    return nil, 'timeout'

	    elseif new_behavior_name == behavior_name then
		    return M.behaviors[behavior_name] 

	    elseif wait_until then 
            waitd.timeout=wait_until-sched.get_time() 
        end
    end
    
end

-- /// Registers a behavior to Torocó. ///
-- This function loads a behavior from a file.
-- After loading the behaviors, add_behavior must be executed.

M.load_behavior = function (behavior_desc, pathname)

    M.add_behavior (behavior_desc, {dofile (pathname..'.lua')})
end


-- /// Add behavior to Torocó. ///
-- This function adds a behavior to Torocó.

M.add_behavior = function (behavior_desc, coroutines) 

    local load_behavior = function()

        -- add behavior to 'M.behaviors'
        M.behaviors [behavior_desc.emitter] = { name = behavior_desc.emitter, events = { }, event_count = 0, input_sources = {}, tasks = {} }

        -- emits new_behavior.
        M.behaviors [behavior_desc.emitter].loaded = true
        sched.signal (M.events.new_behavior, behavior_desc.emitter)
        
        for _, coroutine in ipairs (coroutines) do
            add_coroutine (behavior_desc.emitter, coroutine)
        end
    end

    sched.run (load_behavior)
end


-- Torocó main function
-- toribio_conf_file: configuration filename (optional).

M.run = function(toribio_conf_file)
    if toribio_conf then
        M.load_configuration(toribio_conf_file)
    else
        M.load_configuration('toribio.conf')
    end

    print ('Torocó go!')

    sched.loop()
end

-------------------------------------------------------------------------------

-- load Torocó configuration file.
-- file: configuration filename.

M.load_configuration = function(file)
	local func_conf, err = loadfile(file)
	assert(func_conf,err)
	local conf = toribio.configuration
	local meta_create_on_query 
	meta_create_on_query = {
		__index = function (table, key)
			table[key]=setmetatable({}, meta_create_on_query)
			return table[key]
		end,
	}
	setmetatable(conf, meta_create_on_query)
	setfenv(func_conf, conf)
	func_conf()
	meta_create_on_query['__index']=nil

    sched.run(function()
        for _, section in ipairs({'deviceloaders', 'tasks'}) do
	        for task, conf in pairs(toribio.configuration[section] or {}) do
		        log ('TORIBIOGO', 'DETAIL', 'Processing conf %s %s: %s', section, task, tostring((conf and conf.load) or false))

		        if conf and conf.load then
			        --[[
			        local taskmodule = require (section..'/'..task)
			        if taskmodule.start then
				        local ok = pcall(taskmodule.start,conf)
			        end
			        --]]
			        log ('TORIBIOGO', 'INFO', 'Starting %s %s', section, task)
			        toribio.start(section, task)
		        end
	        end
        end
    end)
end

-------------------------------------------------------------------------------

return M
