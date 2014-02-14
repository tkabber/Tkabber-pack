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
- Run `make install`: it will download tkabber, Tcl/Tk, depended Tcl extensions, and will build it when necessary;
- `iscc tkabber-pack.iss` will create final Tkabber-pack installer, where `iscc` is Inno Setup's command-line tool, which can be found in the InnoSetup installation directory.
