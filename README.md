# ALLIANCE using Toroco

<img src="./logo.png" width="50">

This library is a fork of the original Torocó repo (accessible at https://gitlab.fing.edu.uy/fbenavid/toroco) which provides an implementation of the Subsumption robot control architecture based on Lua programming language and derived tools ([Toribio](https://github.com/xopxe/Toribio), [Lumen](https://github.com/xopxe/lumen)).

It aims at providing new features to support the cooperative control of multi-robot systems, based on the Alliance robotic control architecture.

This library was implemented and tested on a machine running Ubuntu 18.04.4.

## Instalation

The required installations to run ALLIANCE are the same that are required by Toroco, so we recommend the ([Toroco full installation guide](https://gitlab.fing.edu.uy/fbenavid/toroco#installing-nixio)).

In case you are not following the installation guide for Toroco, you will need to install the following dependencies:

- Lua 5.1.5, you can get the source from https://www.lua.org/ftp/
- [Nixio](https://github.com/Neopallium/nixio) which Toribio has as a dependency


Afterwards you should clone this repo and then also clone Toribio and Lumen inside of the Toroco folder:

```
git clone git@github.com:MottiniMauro/alliance.git
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
