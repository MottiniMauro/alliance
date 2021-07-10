from morse.builder import *

collector1 = ATRV()
collector1.translate(x=-1.0, z=0.2)
collector1.properties(Object = True, Graspable = False, Label = "COLLECTOR")

proximity1 = Proximity()
proximity1.translate(0,0,0)
proximity1.properties(Track="Object", Range=20)
proximity1.frequency(2)
collector1.append(proximity1)

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

collector2 = ATRV()
collector2.translate(x=2.0, y=-2.0, z=0.2)
collector2.properties(Object = True, Graspable = False, Label = "COLLECTOR")


keyboard = Keyboard()
keyboard.properties(Speed=1.0)
collector2.append(keyboard)

proximity2 = Proximity()
proximity2.translate(0,0,0)
proximity2.properties(Track="Object", Range=20)
proximity2.frequency(2)
collector2.append(proximity2)

motion2= MotionVW()
collector2.append(motion2)

semanticL2 = SemanticCamera()
semanticL2.translate(x=0.2, y=0.3, z=0.9)
semanticL2.frequency(5)
collector2.append(semanticL2)

semanticR2 = SemanticCamera()
semanticR2.translate(x=0.2, y=-0.3, z=0.9)
semanticR2.frequency(5)
collector2.append(semanticR2)

env = Environment('./sandbox.blend')

proximity1.add_interface('socket')
motion1.add_stream('socket')
motion1.add_service('socket')
semanticL1.add_stream('socket')
semanticR1.add_stream('socket')


proximity2.add_interface('socket')
motion2.add_stream('socket')
motion2.add_service('socket')
semanticL2.add_stream('socket')
semanticR2.add_stream('socket')

env.set_camera_location([10.0, -10.0, 10.0])
env.set_camera_rotation([1.0470, 0, 0.7854])

env.configure_multinode(protocol="socket", distribution={
	"nodeA": [collector1.name],
	"nodeB": [collector2.name]
})