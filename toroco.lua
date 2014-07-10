local M = {}

local toribio = require 'toribio'
local sched = require 'sched'
local mutex = require 'lumen.mutex'

-- Behaviors managed by Torocó

M.behaviors = {}

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

-- Stores the task for each event of the trigger in 'registered_receivers',
-- and registers the event aliases for the trigger.

local register_receiver_event = function(behavior_name, event, event_name, callback)

    if not registered_receivers[event] then
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

-- registers a behavior to Torocó.
-- conf: configuration table from the behavior.
-- triggers: table of triggers (event with callback function).
-- output_events: table of events emitted by the behavior.

M.register_behavior = function(conf, triggers, output_events)

    local task_name = get_task_name(conf)

    M.behaviors[task_name] = { events = output_events }

    -- initialize
    -- sched.signal(senal_primera)
    -- sched.wait(señal_segunda)
    
    -- for each trigger, ...

    for trigger_name, trigger in pairs (triggers) do 

        -- register trigger events
        if trigger.event then
            trigger.events = {trigger.event}
        end

        -- if the event comes from a device, ...
        if conf[trigger_name].emitter.type == 'device' then
            local device = toribio.wait_for_device (conf[trigger_name].emitter.name)             

            --toribio.register_callback (device, trigger.event, function(...)
            --    dispach_signal(conf[trigger_name].emitter.name, trigger.event, ...)
            --end)
            if not device.events or not device.events[trigger.event] then 
                log ('TORIBIO', 'WARN', 'Event not found for device %s: "%s"', tostring(device), tostring(trigger.event))
            end

            register_receiver_event(task_name, device.events[trigger.event], trigger.event, trigger.callback)

            local waitd = {
                device.events[trigger.event]
            }

            local mx = mutex.new()
            local fsynched = mx:synchronize (function(...)
                dispach_signal(...)
            end)

            toribio.sched.sigrun(waitd, fsynched)

        -- if the event doesnt come from a device, ...
        elseif conf[trigger_name].emitter.type == 'behavior' then

            local event = M.behaviors[conf[trigger_name].emitter.name].events[trigger.event]

            register_receiver_event(task_name, event, trigger.callback)

            local waitd = {event}
            local mx = mutex.new()
            local fsynched = mx:synchronize(dispach_signal)

            sched.sigrun(waitd, fsynched)
        else
            -- error
        end
    end
end

return M
