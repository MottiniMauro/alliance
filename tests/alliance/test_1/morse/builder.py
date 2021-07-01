from morse.builder import *

collector1 = ATRV()
collector1.translate(x=1.0, z=0.2)
collector1.properties(Object = True, Graspable = False, Label = "COLLECTOR")

keyboard = Keyboard()
keyboard.properties(Speed=3.0)
collector1.append(keyboard)

proximity = Proximity()
proximity.translate(0,0,0)
proximity.properties(Track="Object", Range=20)
proximity.frequency(2)
collector1.append(proximity)

motion1 = MotionVW()
collector1.append(motion1)

semanticL1 = SemanticCamera()
semanticL1.translate(x=0.2, y=0.3, z=0.9)
semanticL1.frequency(5)
collector1.append(semanticL1)

semanticR1 = SemanticCamera()
semanticR1.translate(x=0.2, y=-0.3, z=0.9)
semanticR1.frequency(5)
collector1.append(semanticR1)

env = Environment('./sandbox.blend')

proximity.add_interface('socket')
motion1.add_stream('socket')
motion1.add_service('socket')
semanticL1.add_stream('socket')
semanticR1.add_stream('socket')

env.set_camera_rotation([1.0470, 0, 0.7854])
