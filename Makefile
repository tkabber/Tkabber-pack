# Tkabber-pack Makefile 
# based on WinTclTk Makefile
# Copyright (c) 2006-2008 Martin Matuska
# Copyright (c) 2014 Vitaly Takmazov
#
CURDIR=	$(shell pwd)
SRCDIR=	$(CURDIR)/src
#
include $(SRCDIR)/defs/defs.mak
include $(SRCDIR)/defs/tools.mak
include $(SRCDIR)/defs/common.mak
#
ROOTDIR?= 	"${CURDIR}"
BUILDDIR?=	"${CURDIR}/tmp/build"
PREFIX?=	"${CURDIR}/tcl"
MAKE_ENV=	PREFIX="${PREFIX}" BUILDDIR="${BUILDDIR}" ROOTDIR="${ROOTDIR}" W64="${W64}"

all: extract-tkabber install
build:
	@cd src && make build ${MAKE_ENV}
install:
	@cd src && make install ${MAKE_ENV}
uninstall:
	@cd src && make uninstall ${MAKE_ENV}
clean:
	@cd src && make clean ${MAKE_ENV}
buildclean:
	@cd src && make buildclean ${MAKE_ENV}
distclean: buildclean 
	@cd src && make distclean ${MAKE_ENV}
allclean: distclean
	@cd src && make allclean ${MAKE_ENV}