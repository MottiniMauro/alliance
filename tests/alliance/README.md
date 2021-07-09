# Alliance tests

## Requirements

To run this test you will need to install the following dependencies:

- Morse Simulator: https://www.openrobots.org/morse/doc/stable/user/installation.html
- Blender: https://www.blender.org/download/
- Python (3.3 or +): https://www.python.org/downloads/
- LuaSocket: http://w3.impa.br/~diego/software/luasocket/home.html


## Running tests

The following steps depend on the amouts of Morse nodes and robots you are running.

First you should run the morse multinode server:
```
multinode_server
```

Then, inside the morse folder of thetest you should open a new tab for each of morse node and run:
```
export MORSE_NODE=nodeN
morse run builder.py 
```
Where the env variable MORSE_NODE is used to identify the node you are running. On this tests we use nodeA, nodeB, nodeC, etc.

The next step consist on starting the process for each of the robots you are running. You should open a new tab for each robot and set the corresponding env variables:

```
export ROBOT_COUNT=N
export ROBOT_ID=N
```

ROBOT_COUNT is used to tell the robot the amout of other robots running in the simulation, the robot then uses this to send messages to the other robots. 

ROBOT_ID tells the robot its identifier number, which is used when communicating with other robots.

Lastly you should start the main processes in each terminar:

```
lua5.1 main.lua
```

## Provided tests

This folder contains 4 example tests, which should provideda basis for generating new tests. The tests provided correspond to the following behaviors:

test_1: example with 1 robot
test_2: example with 2 robot
test_3: example with 3 robot
test_4: example with 1 robot and a task which it cannot complete within the time requiremets. To simulate this the balls where edited in the blender fileused to make them havier and have more friction with the floor.

By edditing the values in each of the main.lua file you should be able to change the behavior of the robots as desired, and changing the morse/builder.py allows you to edit the simulation by adding or removing robots/sensores/objects. Using blender you should also be able to edit the different objects within the simulation and the simulation environment itself.

