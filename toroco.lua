local M = {}

local toribio = require 'toribio'
local sched = require 'lumen.sched'
local mutex = require 'lumen.mutex'

-- Behaviors managed by Torocó

M.behaviors = {}

local events = {
	new_behavior = {}
}
M.events = events

-- List of registered receivers for each event

local registered_receivers = {}

-- This function is executed when Torocó captures a signal.

local dispach_signal = function (event, ...)
    for _, receiver in ipairs(registered_receivers[event]) do
        -- sched.signal(receiver.event_alias, ...) FIXME: Version usando eventos alias
        receiver.callback(event, ...)
    end 

--[[
    if not emisor_está_inhibido (sender, event) then
        for receiver, _ in ipairs(registered_receivers[event]) do
            if (not receptor_está_inhibido (receiver, event)) then
                send (eventos_nombrados.event.receiver)
            end
        end
    end
--]]
end

-- Registers the events that a behavior wants to receive.
-- The data is stored in receivers_events.

local get_task_name = function(conf)
    local config = toribio.configuration['tasks'] or {}    
    for k, v in pairs(config) do
        if v == conf then
            return k
        end
    end
end

-- Registers the dispach singal function to an event

local register_dispacher = function(event)
    local waitd = {
        event
    }

    local mx = mutex.new()
    local fsynched = mx:synchronize (dispach_signal)

    sched.sigrun(waitd, fsynched)
end

-- Stores the task for each event of the trigger in 'registered_receivers',
-- and registers the event aliases for the trigger.

local register_receiver_event = function(behavior_name, event, event_name, callback)

    if not registered_receivers[event] then
        register_dispacher (event)
        registered_receivers[event] = {}
    end

    local receiver = {}
    receiver.name = behavior_name

--[[ FIXME: Version usando eventos alias
    receiver.event_alias = {}


    local waitd = {receiver.event_alias}
--]]

    table.insert(registered_receivers[event], receiver)

    local mx = mutex.new()
    local fsynched = mx:synchronize (function(_, ...)
            callback(event_name, ...)
        end
    )

    receiver.callback = fsynched

--[[ FIXME: Version usando eventos alias
    sched.sigrun(waitd, fsynched)
--]]

end 

-- mystic function

M.wait = function(waitd)
    
end


-- suspend a task until the behavior has been registered to Torocó.

M.wait_for_behavior = function(behavior_name, timeout)
    assert(sched.running_task, 'Must run in a task')

    -- if the behavior is already loaded, return success.

    if M.behaviors[behavior] and M.behaviors[behavior].loaded then
        return M.behaviors[behavior]
    end

    -- else, ...

	local wait_until
	if timeout then 
        wait_until=sched.get_time() + timeout 
    end
    
    local waitd = {M.events.new_behavior}
    if wait_until then 
        waitd.timeout=wait_until-sched.get_time() 
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
-- Each trigger registers a callback function for a list of events.
-- Each output event registers the target function.
-- conf: configuration table from the behavior.
-- triggers: table of triggers (event with callback function).
-- output_events: table of events emitted by the behavior.

M.register_behavior = function(conf, triggers, output_events)

    local task_name = get_task_name(conf)

    M.behaviors[task_name] = { events = output_events }

    -- For each output event of the behavior, ...
    for event, send_to in pairs(conf.events or {}) do

        -- if the receiver is a device, ...
        if send_to.receiver.type == 'device' then

            local device = toribio.wait_for_device (send_to.receiver.name)   
            
            -- Proxy of the target function
            local proxy = function(_, ...)
                device[send_to.receiver.event](...)
            end

            -- registers the proxy for the event.
            register_receiver_event (send_to.receiver.name, output_events[event], event, proxy)
        end
    end
    
    -- for each trigger, ...

    for trigger_name, trigger in pairs (triggers) do 

        if trigger.event then
            trigger.events = {trigger.event}
        end

        -- registers the trigger events.

        -- if the event comes from a device, ...
        if conf[trigger_name].emitter.type == 'device' then

            local device = toribio.wait_for_device (conf[trigger_name].emitter.name)             

            if not device.events or not device.events[trigger.event] then 
                log ('TORIBIO', 'WARN', 'Event not found for device %s: "%s"', tostring(device), tostring(trigger.event))
            end

            register_receiver_event (task_name, device.events[trigger.event], trigger.event, trigger.callback)

        -- if the event doesnt come from a device, ...
        elseif conf[trigger_name].emitter.type == 'behavior' then

            local behavior = M.wait_for_behavior(conf[trigger_name].emitter.name)

            register_receiver_event (task_name, behavior.events[trigger.event], trigger.event, trigger.callback)
        else
            -- error
        end
    end

    -- emits new_behavior.

    M.behaviors[task_name].loaded = true
    sched.signal(M.events.new_behavior, task_name)
end

return M
