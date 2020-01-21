Tkabber-pack
============

Tkabber distribution for Windows and macOS

Download latest release from https://github.com/tkabber/Tkabber-pack/releases/latest

Build requirements
------------------

### Windows

- MSYS environment with [LLVM-MinGW](https://github.com/mstorsjo/llvm-mingw) compiler
- InnoSetup 5

### macOS

- Xcode Command Line Tools
- autoconf automake (Homebrew, MacPorts)

How to build
------------

### Windows

- Configure MSYS to use different compiler: edit `C:\MinGW\msys\1.0\etc\fstab` and replace `C:\MinGW` with path to correct compiler,
e.g. `c:\llvm-mingw                 /mingw`.
- Open "MSYS Command prompt" (e.g. `C:\MinGW\msys\1.0\msys.bat` in default setup) and navigate to Tkabber-pack source directory
- Run `./configure`, then `make install` (or `./configure --host=x86_64-w64-mingw32 && make install` for Win64 build): it will download tkabber, Tcl/Tk, depended Tcl extensions, and will build it when necessary.

## macOS

If you have Xcode Command Line Tools and autotools it should be just `./configure && make install`


## Cross-compile from Linux to Windows

If you have [mingw-w64](https://packages.debian.org/mingw-w64) or [LLVM-MinGW](https://github.com/mstorsjo/llvm-mingw)
installed then it should work as `./configure --host=i686-w64-mingw32 && make install` for 32-bit build
or `./configure --host=x86_64-w64-mingw32 && make install` for 64-bit one.
