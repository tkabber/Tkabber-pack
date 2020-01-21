#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.53)
AC_PACKAGE_VERSION(1.1.2)
AC_INIT([Tkabber-pack], 1.1.2, [], [])

AC_EXEEXT

# Checks for programs.
AC_PROG_MAKE_SET
AC_CHECK_PROG([CURL], [curl], [curl])

AC_CANONICAL_HOST

AS_IF([[test "x$build_os" != "x$host_os"]], [AC_PATH_PROG(TCLSH_PROG, tclsh)])

case $host_os in
    *darwin*)
	HOST_IS=darwin
	DARWIN=1
	TCL_MAKE_DIR=unix
  CMAKE_SYSTEM_NAME=Darwin
  CMAKE_GENERATOR="Unix Makefiles"
	;;
    *linux*)
	HOST_IS=linux
	LINUX=1
	;;
    *mingw*)
	HOST_IS=windows
	WINDOWS=1
	TCL_MAKE_DIR=win
	if test x$build != x$host; then
	   CROSSBUILD=1
	   CMAKE_SYSTEM_NAME=Windows
	   CMAKE_GENERATOR="Unix Makefiles"
	else
	   CMAKE_GENERATOR="MSYS Makefiles"
	fi
	if test x$host_cpu = xx86_64; then
	   W64=1
	fi
	;;
    *) ;;
esac

AC_SUBST(WINDOWS)
AC_SUBST(LINUX)
AC_SUBST(DARWIN)
AC_SUBST(CMAKE_SYSTEM_NAME)
AC_SUBST(CROSSBUILD)
AC_SUBST(CMAKE_GENERATOR)
AC_SUBST(TCL_MAKE_DIR)
AC_SUBST(W64)

AC_OUTPUT([info-after-ru.txt info-after-en.txt Makefile src/defs/defs.mak src/defs/shared.mak src/defs/common.mak])
