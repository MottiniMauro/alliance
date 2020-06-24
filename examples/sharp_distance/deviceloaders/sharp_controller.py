#!/usr/bin/python3
import smbus
import sys
import os
import time
import shutil

port = int(sys.argv[2])
dir = '/home/robot/sharp/' + sys.argv[1] + '/'
value_file = dir + 'value'
signal_file = dir + 'signal'
type = sys.argv[3]
rate = 1.0/float(sys.argv[4])
bus = smbus.SMBus(port+2) # i2c port = 2 + input port

# For multiple sensor support, empirical values
#  are similar for 2Y0A02 and 2Y0A21.
formula = {'2Y0A02':[0.037844, 1.15829]}


addr = 0x01

a = formula[type][0]
b = formula[type][1]

tolerance = rate * 10

print ('Writing value in ' + value_file)

while int(round(time.time())) - os.path.getmtime(signal_file) < tolerance:
        dataL = bus.read_byte_data(addr, 0x42)
        dataH = bus.read_byte_data(addr, 0x43)
        data = (dataH << 8 ) + dataL
	dist_cm = a*(data**b)
	# print(dist_cm)
	f = open(value_file, "w")
	f.write(str(dist_cm) + '\n')
	f.close()
	time.sleep(rate/2.0)

# print ('Python exits')
shutil.rmtree('/home/robot/sharp/')
