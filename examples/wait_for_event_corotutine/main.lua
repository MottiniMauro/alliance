local toroco = require 'toroco.toroco'
local device = toroco.device
local behavior = toroco.behavior
local input = toroco.input


local behaviors = {

    trc_beh1 = {
        output_targets = {
            motor1_setvel = device.trc_motor.setvel2mtr
        };

        input_sources = {
            gate_1 = device.mice.leftbutton,
            gate_2 = device.mice.leftbutton,
            reset = device.mice.rightbutton
        };
    };
};

toroco.add_behaviors (behaviors)

---[[
toroco.add_coroutine (behavior.trc_beh1, function()
    while true do
        print ('\nloop')

        local v1 = toroco.wait_for_input (input.gate_1)
        print ('1st =', v1)

        local v2 = toroco.wait_for_input (input.gate_2)
        print ('2nd =', v2)

        toroco.send_output {motor1_setvel = {88, 0}}
    end
end)
--]]

toroco.run ()


