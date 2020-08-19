-- package.path = package.path..';./socket/lua/?.lua;?.lua;'

local motors = require 'motors_translator'


motors.set_params(10, 5)

v, w = motors.v2_to_angular(10, 5)

print(v, w)

vl, vr = motors.angular_to_v2(v, w)

print(vl, vr)