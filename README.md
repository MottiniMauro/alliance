# ALLIANCE using Toroco

This library is a fork of the original Torocó repo (accessible at https://github.com/AgusCT/Toroco) which provides an implementation of the Subsumption robot control architecture for Lua based on Toribio.

What this version of the library provides is an inclusion of thenew features to provide support for systems based on the ALLIANCE robot control architecture.

## Instalation

To run this library you will need Lua 5.1 install, you can get the source from https://www.lua.org/ftp/

Afterwards you should clone this repo and then also clone Toribio and Lumen inside of the Toroco folder:

```
git clone git@gitlab.fing.edu.uy:fbenavid/toroco.git
cd toroco
git clone git://github.com/xopxe/Toribio.git
mv Toribio toribio
cd toribio 
git clone https://github.com/xopxe/lumen.git
```

## Notes

Some of the examples provided as part of this project also include other dependancies that are required to run them such as:

- Morse Simulator: https://www.openrobots.org/morse/doc/stable/user/installation.html
- Blender: https://www.blender.org/download/
- Python (3.3 or +): https://www.python.org/downloads/
- LuaSocket: http://w3.impa.br/~diego/software/luasocket/home.html