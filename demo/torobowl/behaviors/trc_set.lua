-- /// trc_set ///

local toroco = require 'toroco.toroco'
local params = toroco.params

-- /// Functions ///

local coroutine = function ()

    toroco.set_output {output = params.output_value}
end

return coroutine



