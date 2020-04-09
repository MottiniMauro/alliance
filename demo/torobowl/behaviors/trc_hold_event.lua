-- /// trc_hold_event ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params


local _hold = false
local _set_value = nil

-- /// Functions ///

local set_handler = function (event, ...)

    print ('argss ', select('#', ...))
    -- If the input event has values, set the output
    if select('#', ...) > 1 then
        _set_value = {...}
        toroco.set_output {output = _set_value}

    -- If the input is nil, unset the output 
    elseif _set_value then
        _set_value = nil
        if not _hold then
            toroco.unset_output ()
        else
            print ('holding!')
        end
    end
end

local hold_handler = function (event, val)

    if val then
        
    print ('hold', val)

        _hold = true
    else

    print ('unhold')

        _hold = false
        if not _set_value then
            toroco.unset_output ()
        end
    end
end

return toroco.trigger (input.set, set_handler), 
       toroco.trigger (input.hold, hold_handler)



