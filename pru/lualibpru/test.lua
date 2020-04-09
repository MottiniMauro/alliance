local luapru = require 'luapru'

luapru.init_pru()

luapru.add_sensor('analog_threshold', 0, 1800, 1300)

luapru.add_sensor('analog', 1)

luapru.start_pru()

while true do
    sensor_num, sensor_value = luapru.wait_for_pru_event();
    --if sensor_num == 1 then
    print ('sensor num:', sensor_num, 'value:', sensor_value)
    --end
end

