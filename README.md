Tkabber-pack
============

Tkabber distribution for Windows 

Download latest release from https://github.com/tkabber/Tkabber-pack/releases/latest

Build requirements
------------------

- MSYS environment with [LLVM-MinGW](https://github.com/mstorsjo/llvm-mingw) compiler
- InnoSetup 5

How to build
------------
- Configure MSYS to use different compiler: edit `C:\MinGW\msys\1.0\etc\fstab` and replace `C:\MinGW` with path to correct compiler,
e.g. `c:\llvm-mingw                 /mingw`.
- Open "MSYS Command prompt" (e.g. `C:\MinGW\msys\1.0\msys.bat` in default setup) and navigate to Tkabber-pack source directory
- Run `configure`, then `make install` (or `make W64=1 install` for Win64 build): it will download tkabber, Tcl/Tk, depended Tcl extensions, and will build it when necessary.
