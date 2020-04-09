local toroco = require 'toroco.toroco'
local device = require 'toroco.device'
local sched = require 'lumen.sched'

local CreateAttributes = function(attributes, new_attributes)
	local _functions = {}
	local _changed = {}
	local _mt = {};

    local on_new_attribute = new_attributes['on_new_attribute'] or attributes['on_new_attribute']
    if not type(on_new_attribute) == 'function' then
        on_new_attribute = nil
    end

    local temp = {}
				
	for k, v in pairs(new_attributes) do
		if type(v) == 'function' and string.match(k, "^on_.+_changed$") then
			_functions[k] = v
		else
            if type(k) == 'number' and v.id then
                temp[v.id] = v
                k = v.id
            else
                temp[k] = v
            end
        end
	end

    new_attributes = temp
	
	for k, v in pairs(attributes) do
		if type(v) == 'function' and string.match(k, "^on_.+_changed$") then
			_functions[k] = v
		else
			if new_attributes[k] then
				_changed[k] = new_attributes[k]
			else
				new_attributes[k] = v
			end
		end
	end

    for k, v in pairs(new_attributes) do
        if on_new_attribute then
            on_new_attribute(new_attributes, k, v)        
        end
    end

	setmetatable(
		_functions,
		{
		__index = function (self, key) 
			if rawget(self, key) then		
				return rawget(self, key)
			else
				--if type(new_attributes[key]) == 'function' then
				--	return new_attributes[key](new_attributes)
				--else
					return new_attributes[key]
				--end
			end
		end;
		
		__newindex = function (self, key, value)
			if type(value) == 'function' and string.match(key, "^on_.+_changed$") then
				rawset(self, key, value)
			else
				local onChanged = rawget(self, 'on_'..key..'_changed')
				
				new_attributes[key] = value
				
				if onChanged then
					onChanged (new_attributes, value)
				end
			end
			
		end;
		}
	)

	for k, v in pairs(_changed) do
		local onChanged = rawget(_functions, 'on_'..k..'_changed')
		if onChanged then
			onChanged (_functions, v)
		end
	end
	
	return _functions
end

Component = function (name) 
	return function (attributes)
		_G[name] = function (new_attributes)
			local t = CreateAttributes(attributes, new_attributes)

            local meta = getmetatable(t)

            meta.__component_type = name

            meta.__call = function(table,...)
                local on_call = table['on_call']
			    if on_call then
				    on_call (table, ...)
			    end
            end

            t = setmetatable(t, meta)
			
			local on_create = t['on_create']
			if on_create then
				on_create (t)
			end
			
			if t.id then
				_G[t.id] = t
			end
			return t
		end
		return _G[name]
	end
end

Component "Behavior" {
    name = nil;
    triggers = nil;
    events = nil;

    on_new_attribute = function(self, k, v)

        self.triggers = self.triggers or {}
        self.events = self.events or {}

        if (getmetatable(v) or {}).__component_type == 'Trigger' then
            self.triggers[v.id] = v
        elseif (getmetatable(v) or {}).__component_type == 'Output' then
            self.events[v.id] = v.event
        end
    end;

    on_create = function(self)
        self.name = self.id

        toroco.new_behavior(self)
    end
}

Component 'Output' {
    event = nil;

    on_event_changed = function(self, new_value)
        
    end;

    on_call = function(self, ...)
        sched.signal (self.event, ...)
    end;

    on_create = function(self)
        self.event = {}
    end
}

Component 'Trigger' {
    on_call = function(self, ...)
        self.callback(...)    
    end;
}

Component 'Inhibition' {
    active = false;
    event = nil;

    on_active_changed = function(self, active)
        if active then
            toroco.inhibit(event)
        else
            toroco.release_inhibition(event)
        end   
    end;
}
