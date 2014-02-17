Tkabber-pack
============

Tkabber distribution for Windows 

Download latest release from https://github.com/tkabber/Tkabber-pack/releases/latest

Build requirements
------------------

- MSYS environment with MinGW compiler
- InnoSetup 5

How to build
------------
- Open "MSYS Command prompt" (e.g. `C:\MinGW\msys\1.0\msys.bat` in default setup) and navigate to Tkabber-pack source directory
- Run `configure`, then `make install` (or `make W64=1 install` for Win64 build (MinGW-W64 required)): it will download tkabber, Tcl/Tk, depended Tcl extensions, and will build it when necessary.