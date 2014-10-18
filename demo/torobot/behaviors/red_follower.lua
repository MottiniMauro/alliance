-- /// trc_turn ///

local toroco = require 'toroco.toroco'
local input = toroco.input
local params = toroco.params

-- /// Functions ///

local handler1 = function (event, x, y)

    print ('\nred follower: x =', x, ' y =', y)
end

return toroco.trigger (input.update, handler1)



