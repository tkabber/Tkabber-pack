#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.53)
AC_PACKAGE_VERSION(1.1.2)
AC_INIT([Tkabber-pack], 1.1.2, [], [])

AC_EXEEXT

# Checks for programs.
AC_PROG_MAKE_SET
AC_CHECK_PROG([CURL], [curl], [curl])

TEA_INIT()

AS_IF([[test "x$build" != "x$host"]], [AC_PATH_PROG(TCLSH_PROG, tclsh)], [TEA_PROG_TCLSH])

AC_OUTPUT([info-after-ru.txt info-after-en.txt Makefile src/defs/defs.mak src/defs/shared.mak])
