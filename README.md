# ALLIANCE using Toroco

<img src="./logo.png" width="50">

This library is a fork of the original Torocó repo (accessible at https://gitlab.fing.edu.uy/fbenavid/toroco) which provides an implementation of the Subsumption robot control architecture based on Lua programming language and derived tools ([Toribio](https://github.com/xopxe/Toribio), [Lumen](https://github.com/xopxe/lumen)).

It aims at providing new features to support the cooperative control of multi-robot systems, based on the Alliance robotic control architecture.

This library was implemented and tested on a machine running Ubuntu 18.04.4.

## Instalation

To run this library you will need Lua 5.1 install, you can get the source from https://www.lua.org/ftp/

Afterwards you should clone this repo and then also clone Toribio and Lumen inside of the Toroco folder:

```
git clone git@gitlab.fing.edu.uy:mauro.mottini/alliance.git
cd toroco
git clone git://github.com/xopxe/Toribio.git
mv Toribio toribio
cd toribio 
git clone git://github.com/xopxe/lumen.git
```

## Notes

Some of the examples provided as part of this project also include other dependancies that are required to run them such as:

- Morse Simulator: https://www.openrobots.org/morse/doc/stable/user/installation.html
- Blender: https://www.blender.org/download/
- Python (3.3 or +): https://www.python.org/downloads/
- LuaSocket: http://w3.impa.br/~diego/software/luasocket/home.html