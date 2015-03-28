# Tkabber-pack defs
# based on WinTclTk defs
# Copyright (c) 2006-2008 Martin Matuska
# Copyright (c) 2014 Vitaly Takmazov
#
all: install
install: extract-tkabber install-tcl install-tk install-tdom install-memchan install-tls install-tkimg install-trf install-tcludp install-tclvfs install-tcllib install-bwidget install-winico install-snack install-twapi install-tkcon
uninstall: uninstall-tcl uninstall-tk uninstall-tdom uninstall-memchan uninstall-tls uninstall-tkimg uninstall-openssl uninstall-trf uninstall-tcludp uninstall-tclvfs uninstall-tcllib uninstall-bwidget uninstall-winico uninstall-snack uninstall-twapi uninstall-tkcon 
clean: clean-tcl clean-tk clean-tdom clean-memchan clean-tls clean-tkimg clean-openssl clean-trf clean-tcludp clean-tclvfs clean-tcllib clean-bwidget clean-winico clean-snack clean-twapi clean-tkcon
distclean: distclean-tcl distclean-tk distclean-tdom distclean-memchan distclean-tls distclean-tkimg distclean-openssl distclean-trf distclean-tcludp distclean-tclvfs distclean-tcllib distclean-bwidget distclean-winico distclean-snack distclean-twapi distclean-tkcon

# directories
${DISTFILES}:
	@[ -d "${DISTFILES}" ] || mkdir -p ${DISTFILES}

${BUILDDIR}:
	@[ -d "${BUILDDIR}" ] || mkdir -p ${BUILDDIR}

# tcl	
fetch-tcl: ${DISTFILES} ${DISTFILES}/tcl${TCLTK_VERSION}-src.tar.gz 
${DISTFILES}/tcl${TCLTK_VERSION}-src.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcl/tcl${TCLTK_VERSION}-src.tar.gz"

extract-tcl: fetch-tcl ${BUILDDIR} ${BUILDDIR}/tcl${TCLTK_VERSION} 
${BUILDDIR}/tcl${TCLTK_VERSION}:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/tcl${TCLTK_VERSION}-src.tar.gz.md5 || exit 1
	@cd ${BUILDDIR} && tar xfz ${DISTFILES}/tcl${TCLTK_VERSION}-src.tar.gz

configure-tcl: extract-tcl ${BUILDDIR}/tcl${TCLTK_VERSION}/win/Makefile
${BUILDDIR}/tcl${TCLTK_VERSION}/win/Makefile:
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION}/win && ./configure --prefix=${PREFIX} --enable-shared --enable-threads $(WIN64_CFLAGS)

build-tcl: configure-tcl ${BUILDDIR} ${BUILDDIR}/tcl${TCLTK_VERSION}/win/tclsh86.exe
${BUILDDIR}/tcl${TCLTK_VERSION}/win/tclsh86.exe:
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION}/win && make && strip *.exe *.dll

install-tcl: build-tcl ${PREFIX}/lib/tclConfig.sh
${PREFIX}/lib/tclConfig.sh:
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION}/win && make install

uninstall-tcl:
	@-cd ${PREFIX}/bin && rm tcl*.dll tclsh*.exe
	@-cd ${PREFIX}/lib && rm -rf dde1.2 libtclstub*.a tcl* libtcl*.a reg1.1 tclConfig.sh
	@-cd ${PREFIX}/include && rm tclDecls.h tcl.h tclPlatDecls.h
	
clean-tcl:
	@-cd ${BUILDDIR}/tcl${TCLTK_VERSION}/win && make clean

distclean-tcl:
	@-rm -rf ${BUILDDIR}/tcl${TCLTK_VERSION}

# tk
fetch-tk: ${DISTFILES} ${DISTFILES}/tk${TCLTK_VERSION}-src.tar.gz 
${DISTFILES}/tk${TCLTK_VERSION}-src.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcl/tk${TCLTK_VERSION}-src.tar.gz"

extract-tk: fetch-tk ${BUILDDIR} ${BUILDDIR}/tk${TCLTK_VERSION} 
${BUILDDIR}/tk${TCLTK_VERSION}:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/tk${TCLTK_VERSION}-src.tar.gz.md5 || exit 1
	@cd ${BUILDDIR} && tar xfz ${DISTFILES}/tk${TCLTK_VERSION}-src.tar.gz
	@cd ${BUILDDIR}/tk${TCLTK_VERSION} && patch -p0 < ${PATCHDIR}/tk.patch

configure-tk: install-tcl extract-tk ${BUILDDIR}/tk${TCLTK_VERSION}/win/Makefile 
${BUILDDIR}/tk${TCLTK_VERSION}/win/Makefile:
	@cd ${BUILDDIR}/tk${TCLTK_VERSION}/win && ./configure --prefix=${PREFIX} --enable-shared --enable-threads

build-tk: configure-tk ${BUILDDIR}/tk${TCLTK_VERSION}/win/wish86.exe 
${BUILDDIR}/tk${TCLTK_VERSION}/win/wish86.exe:
	@cd ${BUILDDIR}/tk${TCLTK_VERSION}/win && make && strip *.exe *.dll

install-tk: build-tk ${PREFIX}/lib/tkConfig.sh 
${PREFIX}/lib/tkConfig.sh:
	@cd ${BUILDDIR}/tk${TCLTK_VERSION}/win && make install
	
uninstall-tk:
	@-cd ${PREFIX}/bin && rm tk*.dll wish*.exe
	@-cd ${PREFIX}/lib && rm -rf tk* libtk*.a libtkstub*.a tkConfig.sh
	@-cd ${PREFIX}/include && rm -rf X11 tk.h tkDecls.h tkIntXlibDecls.h tkPlatDecls.h 

clean-tk:
	@-cd ${BUILDDIR}/tk${TCLTK_VERSION}/win && make clean

distclean-tk:
	@-rm -rf ${BUILDDIR}/tk${TCLTK_VERSION}

# tdom
fetch-tdom: ${DISTFILES} ${DISTFILES}/tDOM-${TDOM_VERSION}-git.tgz 
${DISTFILES}/tDOM-${TDOM_VERSION}-git.tgz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} -O tDOM-${TDOM_VERSION}-git.tgz "https://github.com/tDOM/tdom/archive/363cbda3ac91b8955edbfd2b64625c725385d5b4.tar.gz"

extract-tdom: fetch-tdom ${BUILDDIR} ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4
${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/tDOM-${TDOM_VERSION}-git.tgz.md5 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/tDOM-${TDOM_VERSION}-git.tgz


configure-tdom: install-tcl extract-tdom ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4/Makefile 
${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4/Makefile:
	@cd ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4 && ./configure --prefix="${PREFIX}" --with-tcl="${PREFIX}/lib"	

build-tdom: configure-tdom ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4/tdom${TDOM_LIBVER}.dll
${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4/tdom${TDOM_LIBVER}.dll:
	@cd ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4 && make && strip *.dll

install-tdom: build-tdom ${PREFIX}/lib/tdom${TDOM_VERSION}
${PREFIX}/lib/tdom${TDOM_VERSION}: 
	@cd ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4 && make install
	@mkdir ${PREFIX}/lib/tdom${TDOM_VERSION}/doc
	@cp ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4/LICENSE ${PREFIX}/lib/tdom${TDOM_VERSION}
	
uninstall-tdom:
	@-cd ${PREFIX}/lib && rm -rf tdom${TDOM_VERSION} tdomConfig.sh
	@-cd ${PREFIX}/include && rm tdom.h
	@-cd ${PREFIX}/man && rm -rf mann

clean-tdom: 
	@-cd ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4 && make clean 

distclean-tdom: 
	@-rm -rf ${BUILDDIR}/tdom-363cbda3ac91b8955edbfd2b64625c725385d5b4

# tkimg
fetch-tkimg: ${DISTFILES} ${DISTFILES}/tkimg${TKIMG_VERSION}.tar.gz
${DISTFILES}/tkimg${TKIMG_VERSION}.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/tkimg/${TKIMG_SHORT}/tkimg${TKIMG_VERSION}.tar.gz"

extract-tkimg: fetch-tkimg ${BUILDDIR} ${BUILDDIR}/tkimg${TKIMG_SHORT}
${BUILDDIR}/tkimg${TKIMG_SHORT}:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/tkimg${TKIMG_VERSION}.tar.gz.md5 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/tkimg${TKIMG_VERSION}.tar.gz
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && patch -p0 < ${PATCHDIR}/tkimg.patch
	@-cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && rm config.cache && find . -name Makefile -exec rm {} \;
	@-cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && find . -name config.status -exec rm {} \;

configure-tkimg: install-tk extract-tkimg ${BUILDDIR}/tkimg${TKIMG_SHORT}/libjpeg/Makefile ${BUILDDIR}/tkimg${TKIMG_SHORT}/Makefile
${BUILDDIR}/tkimg${TKIMG_SHORT}/libjpeg/Makefile:
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT}/libjpeg && ./configure --prefix=${PREFIX} --enable-threads --enable-shared
${BUILDDIR}/tkimg${TKIMG_SHORT}/Makefile:
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && ./configure --prefix=${PREFIX} --enable-threads --enable-shared --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-tkimg: configure-tkimg ${BUILDDIR}/tkimg${TKIMG_SHORT}/base/tkimg${TKIMG_LIBVER}.dll 
${BUILDDIR}/tkimg${TKIMG_SHORT}/base/tkimg${TKIMG_LIBVER}.dll:
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && make && strip */*.dll

install-tkimg: build-tkimg ${PREFIX}/lib/Img${TKIMG_VERSION}
${PREFIX}/lib/Img${TKIMG_VERSION}: 
	@mkdir -p ${PREFIX}/lib/Img${TKIMG_VERSION}/doc
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && make DTPLITE="$(PREFIX)/bin/tclsh86.exe $(BUILDDIR)/tcllib-$(TCLLIB_VERSION)/apps/dtplite" install
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && cp license.terms ${PREFIX}/lib/Img${TKIMG_VERSION}
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT}/doc && cp *.css *.htm ${PREFIX}/lib/Img${TKIMG_VERSION}/doc

uninstall-tkimg:
	@-cd ${PREFIX} && rm -rf lib/Img${TKIMG_VERSION} include/tkimg*.h include/jpegtcl*.h include/pngtcl*.h include/tifftcl*.h include/zlibtcl*.h

clean-tkimg:
	@-cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && make clean

distclean-tkimg:
	@-rm -rf ${BUILDDIR}/tkimg${TKIMG_SHORT}

# tls
fetch-tls: ${DISTFILES} ${DISTFILES}/tls${TLS_VERSION}.tar.gz
${DISTFILES}/tls${TLS_VERSION}.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} -O tls${TLS_VERSION}.tar.gz "http://tls.cvs.sourceforge.net/viewvc/tls/tls/?view=tar"

extract-tls: fetch-tls ${BUILDDIR} ${BUILDDIR}/tls
${BUILDDIR}/tls:
#	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/tls${TLS_VERSION}.tar.gz.md5 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/tls${TLS_VERSION}.tar.gz
	@cd ${BUILDDIR}/tls && patch -p0 < ${PATCHDIR}/tls.patch

configure-tls: install-openssl extract-tls ${BUILDDIR}/tls/Makefile
${BUILDDIR}/tls/Makefile:
	@cd ${BUILDDIR}/tls && autoreconf -if && LIBS="-lws2_32 -lgdi32 -lcrypt32 -static-libgcc" ./configure --prefix=${PREFIX} --enable-threads --enable-shared --with-ssl-dir=${PREFIX}

build-tls: configure-tls ${BUILDDIR}/tls/tls${TLS_LIBVER}.dll 
${BUILDDIR}/tls/tls${TLS_LIBVER}.dll:
	@cd ${BUILDDIR}/tls && make && strip *.dll

install-tls: build-tls ${PREFIX}/lib/tls${TLS_VERSION}
${PREFIX}/lib/tls${TLS_VERSION}: 
	@mkdir -p ${PREFIX}/lib/tls${TLS_VERSION}
	@cd ${BUILDDIR}/tls && make install
	@cd ${BUILDDIR}/tls && cp license.terms tls.htm ${PREFIX}/lib/tls${TLS_VERSION} 

uninstall-tls:
	@-cd ${PREFIX} && rm -rf lib/tls${TLS_VERSION} include/tls.h

clean-tls:
	@-cd ${BUILDDIR}/tls && make clean

distclean-tls:
	@-rm -rf ${BUILDDIR}/tls

# tcllib
fetch-tcllib: ${DISTFILES} ${DISTFILES}/tcllib-${TCLLIB_VERSION}.tar.gz 
${DISTFILES}/tcllib-${TCLLIB_VERSION}.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "https://github.com/tcltk/tcllib/archive/tcllib_$(subst .,_,${TCLLIB_VERSION}).tar.gz" -O "tcllib-${TCLLIB_VERSION}.tar.gz"

extract-tcllib: fetch-tcllib ${BUILDDIR} ${BUILDDIR}/tcllib-${TCLLIB_VERSION} 
${BUILDDIR}/tcllib-${TCLLIB_VERSION}:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/tcllib-${TCLLIB_VERSION}.tar.gz.md5 || exit 1
	@cd ${BUILDDIR} && tar --transform 's/-tcllib_$(subst .,_,${TCLLIB_VERSION})/-${TCLLIB_VERSION}/' -xf ${DISTFILES}/tcllib-${TCLLIB_VERSION}.tar.gz

configure-tcllib: install-tcl extract-tcllib ${BUILDDIR}/tcllib-${TCLLIB_VERSION}/Makefile 
${BUILDDIR}/tcllib-${TCLLIB_VERSION}/Makefile:
	@cd ${BUILDDIR}/tcllib-${TCLLIB_VERSION} && ./configure --prefix=${PREFIX}

build-tcllib: configure-tcllib 

install-tcllib: build-tcllib ${PREFIX}/lib/tcllib${TCLLIB_SHORT}/pkgIndex.tcl 
${PREFIX}/lib/tcllib${TCLLIB_SHORT}/pkgIndex.tcl:
	@cd ${BUILDDIR}/tcllib-${TCLLIB_VERSION} && make install-libraries

uninstall-tcllib:
	@-cd ${PREFIX}/lib && rm -rf tcllib${TCLLIB_VERSION}

clean-tcllib:
	@-cd ${BUILDDIR}/tcllib-${TCLLIB_VERSION} && make clean

distclean-tcllib:
	@-rm -rf ${BUILDDIR}/tcllib-${TCLLIB_VERSION}

# bwidget
fetch-bwidget: ${DISTFILES} ${DISTFILES}/bwidget-${BWIDGET_VERSION}.tar.gz 
${DISTFILES}/bwidget-${BWIDGET_VERSION}.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcllib/bwidget-${BWIDGET_VERSION}.tar.gz"

extract-bwidget: fetch-bwidget ${BUILDDIR} ${BUILDDIR}/bwidget-${BWIDGET_VERSION} 
${BUILDDIR}/bwidget-${BWIDGET_VERSION}:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/bwidget-${BWIDGET_VERSION}.tar.gz.md5 || exit 1
	@cd ${BUILDDIR} && tar xfz ${DISTFILES}/bwidget-${BWIDGET_VERSION}.tar.gz

configure-bwidget: extract-bwidget
build-bwidget: configure-bwidget
 
install-bwidget: build-bwidget ${PREFIX}/lib/BWidget${BWIDGET_VERSION}/pkgIndex.tcl
${PREFIX}/lib/BWidget${BWIDGET_VERSION}/pkgIndex.tcl:
	@mkdir -p ${PREFIX}/lib/BWidget${BWIDGET_VERSION}
	@cp -Rp ${BUILDDIR}/bwidget-${BWIDGET_VERSION}/* ${PREFIX}/lib/BWidget${BWIDGET_VERSION}

uninstall-bwidget:
	@-cd ${PREFIX}/lib && rm -rf BWidget${BWIDGET_VERSION}

clean-bwidget:

distclean-bwidget:
	@-rm -rf ${BUILDDIR}/bwidget-${BWIDGET_VERSION}

# twapi
fetch-twapi: ${DISTFILES} ${DISTFILES}/twapi-${TWAPI_VERSION}.zip ${DISTFILES}/twapi-docs-${TWAPI_VERSION}.zip
${DISTFILES}/twapi-${TWAPI_VERSION}.zip:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/twapi/twapi-${TWAPI_VERSION}.zip"
${DISTFILES}/twapi-docs-${TWAPI_VERSION}.zip:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/twapi/twapi-docs-${TWAPI_VERSION}.zip"

extract-twapi: fetch-twapi install-unzip ${BUILDDIR} ${BUILDDIR}/twapi ${BUILDDIR}/twapi/website
${BUILDDIR}/twapi:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/twapi-${TWAPI_VERSION}.zip.md5 || exit 1
	@cd ${BUILDDIR} && ${UNZIP} ${DISTFILES}/twapi-${TWAPI_VERSION}.zip
${BUILDDIR}/twapi/website:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/twapi-docs-${TWAPI_VERSION}.zip.md5 || exit 1
	@cd ${BUILDDIR}/twapi && ${UNZIP} ${DISTFILES}/twapi-docs-${TWAPI_VERSION}.zip

configure-twapi: extract-twapi
build-twapi: configure-twapi

install-twapi: build-twapi ${PREFIX}/lib/twapi${TWAPI_VERSION}/pkgIndex.tcl
${PREFIX}/lib/twapi${TWAPI_VERSION}/pkgIndex.tcl:
	@mkdir -p ${PREFIX}/lib/twapi${TWAPI_VERSION}
	@cp -Rp ${BUILDDIR}/twapi/* ${PREFIX}/lib/twapi${TWAPI_VERSION}

uninstall-twapi:
	@-cd ${PREFIX}/lib && rm -rf twapi${TWAPI_VERSION}
	
clean-twapi:

distclean-twapi:
	@-rm -rf ${BUILDDIR}/twapi

# tcludp
fetch-tcludp: $(DISTFILES) $(DISTFILES)/tcludp-$(TCLUDP_VERSION).tar.gz 
$(DISTFILES)/tcludp-$(TCLUDP_VERSION).tar.gz:
	@[ -x "$(WGET)" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd $(DISTFILES) && $(WGET) $(WGET_FLAGS) "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/tcludp/tcludp-$(TCLUDP_VERSION).tar.gz"

extract-tcludp: fetch-tcludp $(BUILDDIR) $(BUILDDIR)/tcludp-$(TCLUDP_VERSION)
$(BUILDDIR)/tcludp-$(TCLUDP_VERSION):
	@cd $(DISTFILES) && md5sum -c $(MD5SUMS)/tcludp-$(TCLUDP_VERSION).tar.gz.md5 || exit 1
	@-cd $(BUILDDIR) && tar xfz $(DISTFILES)/tcludp-$(TCLUDP_VERSION).tar.gz

configure-tcludp: extract-tcludp install-tcl $(BUILDDIR)/tcludp-$(TCLUDP_VERSION)/Makefile
$(BUILDDIR)/tcludp-$(TCLUDP_VERSION)/Makefile:
	@cd $(BUILDDIR)/tcludp-$(TCLUDP_VERSION) && ./configure --prefix=$(PREFIX) --enable-threads --enable-shared

build-tcludp: configure-tcludp $(BUILDDIR)/tcludp-$(TCLUDP_VERSION)/udp$(TCLUDP_LIBVER).dll 
$(BUILDDIR)/tcludp-$(TCLUDP_VERSION)/udp$(TCLUDP_LIBVER).dll:
	@cd $(BUILDDIR)/tcludp-$(TCLUDP_VERSION) && make && strip *.dll

install-tcludp: build-tcludp $(PREFIX)/lib/udp$(TCLUDP_VERSION)
$(PREFIX)/lib/udp$(TCLUDP_VERSION): 
	@cd $(BUILDDIR)/tcludp-$(TCLUDP_VERSION) && make install
	@cd ${BUILDDIR}/tcludp-$(TCLUDP_VERSION) && cp license.terms $(PREFIX)/lib/udp${TCLUDP_VERSION}

uninstall-tcludp:
	@-cd $(PREFIX)/lib && rm -rf udp$(TCLUDP_VERSION)
	@-cd $(PREFIX) && rm -rf man

clean-tcludp:
	@-cd $(BUILDDIR)/tcludp-$(TCLUDP_VERSION) && make clean

distclean-tcludp:
	@-rm -rf $(BUILDDIR)/tcludp-$(TCLUDP_VERSION)	
	
# tclvfs
fetch-tclvfs: $(DISTFILES) $(DISTFILES)/tclvfs-$(TCLVFS_VERSION).tar.gz 
$(DISTFILES)/tclvfs-$(TCLVFS_VERSION).tar.gz :
	@[ -x "$(WGET)" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd $(DISTFILES) && $(WGET) $(WGET_FLAGS) -O tclvfs-$(TCLVFS_VERSION).tar.gz "http://tclvfs.cvs.sourceforge.net/viewvc/tclvfs/tclvfs/?view=tar"

extract-tclvfs: fetch-tclvfs $(BUILDDIR) $(BUILDDIR)/tclvfs
$(BUILDDIR)/tclvfs:
#	@cd $(DISTFILES) && md5sum -c $(MD5SUMS)/tclvfs-$(TCLVFS_VERSION).tar.gz.md5 || exit 1
	@-cd $(BUILDDIR) && tar xfz $(DISTFILES)/tclvfs-$(TCLVFS_VERSION).tar.gz

configure-tclvfs: extract-tclvfs install-tcl $(BUILDDIR)/tclvfs/Makefile
$(BUILDDIR)/tclvfs/Makefile:
	@cd $(BUILDDIR)/tclvfs && CFLAGS="${TCLVFS_CFLAGS}" ./configure --prefix=$(PREFIX) --enable-threads --enable-shared $(WIN64_CFLAGS)

build-tclvfs: configure-tclvfs $(BUILDDIR)/tclvfs/vfs$(TCLVFS_LIBVER).dll 
$(BUILDDIR)/tclvfs/vfs$(TCLVFS_LIBVER).dll:
	@cd $(BUILDDIR)/tclvfs && make && strip *.dll

install-tclvfs: build-tclvfs $(PREFIX)/lib/vfs$(TCLVFS_VERSION)
$(PREFIX)/lib/vfs$(TCLVFS_VERSION): 
	@cd $(BUILDDIR)/tclvfs && make install

uninstall-tclvfs:
	@-cd $(PREFIX)/lib && rm -rf vfs$(TCLVFS_VERSION)
	@-cd $(PREFIX) && rm -rf man

clean-tclvfs:
	@-cd $(BUILDDIR)/tclvfs && make clean

distclean-tclvfs:
	@-rm -rf $(BUILDDIR)/tclvfs

# memchan
fetch-memchan: $(DISTFILES)/Memchan$(MEMCHAN_VERSION).tar.gz
$(DISTFILES)/Memchan$(MEMCHAN_VERSION).tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 )
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/memchan/$(MEMCHAN_VERSION)/Memchan$(MEMCHAN_VERSION).tar.gz"
		
extract-memchan: fetch-memchan $(BUILDDIR) $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)
$(BUILDDIR)/Memchan$(MEMCHAN_VERSION):
	@cd ${DISTFILES} && md5sum -c $(MD5SUMS)/Memchan$(MEMCHAN_VERSION).tar.gz.md5 || exit 1
	@cd $(BUILDDIR) && tar xfz $(DISTFILES)/Memchan$(MEMCHAN_VERSION).tar.gz

configure-memchan: extract-memchan install-tcl install-tcllib $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Makefile
$(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Makefile:
	@cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && ./configure --prefix=$(PREFIX) --enable-threads --enable-shared  --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-memchan: configure-memchan $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Memchan${MEMCHAN_LIBVER}.dll 
$(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Memchan${MEMCHAN_LIBVER}.dll :
	@cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && make && strip *.dll

install-memchan: build-memchan $(PREFIX)/lib/Memchan$(MEMCHAN_VERSION)/pkgIndex.tcl
$(PREFIX)/lib/Memchan$(MEMCHAN_VERSION)/pkgIndex.tcl:
	@cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && make install
	
uninstall-memchan:
	@-cd $(PREFIX)/lib && rm -rf Memchan${MEMCHAN_VERSION}

clean-memchan:
	@-cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && make clean

distclean-memchan:
	@-rm -rf $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)	

# trf
fetch-trf: $(DISTFILES)/trf$(TRF_VERSION).tar.gz
$(DISTFILES)/trf$(TRF_VERSION).tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 )
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/project/tcltrf/tcltrf/$(TRF_VERSION)/trf$(TRF_VERSION).tar.gz"
		
extract-trf: fetch-trf $(BUILDDIR) $(BUILDDIR)/trf$(TRF_VERSION)/win/Makefile.gnu
$(BUILDDIR)/trf$(TRF_VERSION)/win/Makefile.gnu:
	@cd ${DISTFILES} && md5sum -c $(MD5SUMS)/trf$(TRF_VERSION).tar.gz.md5 || exit 1
	@cd $(BUILDDIR) && tar xfz $(DISTFILES)/trf$(TRF_VERSION).tar.gz
	@-cd $(BUILDDIR)/trf$(TRF_VERSION) && patch -p0 < $(PATCHDIR)/trf.patch

configure-trf: extract-trf install-tcl install-openssl $(BUILDDIR)/trf$(TRF_VERSION)/Makefile
$(BUILDDIR)/trf$(TRF_VERSION)/Makefile:
	@cd $(BUILDDIR)/trf$(TRF_VERSION) && ./configure --prefix=$(PREFIX) --enable-threads --enable-static --enable-shared --with-ssl-dir=$(PREFIX) --with-zlib-include-dir=$(BUILDDIR)/tcl${TCLTK_VERSION}/compat/zlib

build-trf: configure-trf $(BUILDDIR)/trf$(TRF_VERSION)/Trf$(TRF_LIBVER).dll 
$(BUILDDIR)/trf$(TRF_VERSION)/Trf$(TRF_LIBVER).dll:
	@cd $(BUILDDIR)/trf$(TRF_VERSION) && make

install-trf: build-trf  $(PREFIX)/lib/trf$(TRF_VERSION)/pkgIndex.tcl
$(PREFIX)/lib/trf$(TRF_VERSION)/pkgIndex.tcl:
	@mkdir -p $(PREFIX)/lib/trf$(TRF_VERSION)/doc
	@cd $(BUILDDIR)/trf$(TRF_VERSION) && make install
	@cp -rf $(BUILDDIR)/trf$(TRF_VERSION)/doc/html/* $(BUILDDIR)/trf$(TRF_VERSION)/doc/license.terms \
		$(PREFIX)/lib/trf$(TRF_VERSION)/doc
	
uninstall-trf:
	@-cd $(PREFIX)/lib && rm -rf trf$(TRF_VERSION)

clean-trf:
	@-cd $(BUILDDIR)/trf$(TRF_VERSION) && make clean

distclean-trf:
	@-rm -rf $(BUILDDIR)/trf$(TRF_VERSION)
	
# winico
fetch-winico: ${DISTFILES} ${DISTFILES}/winico${subst .,,$(WINICO_VERSION)}cvs.zip
${DISTFILES}/winico${subst .,,$(WINICO_VERSION)}cvs.zip:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} -O winico${subst .,,$(WINICO_VERSION)}cvs.zip "https://github.com/vitalyster/winico/archive/master.zip"

extract-winico: install-unzip fetch-winico ${BUILDDIR} ${BUILDDIR}/winico-master
${BUILDDIR}/winico-master:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/winico${subst .,,$(WINICO_VERSION)}cvs.zip.md5 || exit 1
	@cd ${BUILDDIR} && $(UNZIP) ${DISTFILES}/winico${subst .,,$(WINICO_VERSION)}cvs.zip
	@-cd $(BUILDDIR)/winico-master && patch -p1 < $(PATCHDIR)/winico.patch

configure-winico: install-tk build-tcllib extract-winico ${BUILDDIR}/winico-master/Makefile
${BUILDDIR}/winico-master/Makefile:
	@cd ${BUILDDIR}/winico-master && ./configure --prefix=${PREFIX} --enable-threads --enable-shared --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-winico: configure-winico ${BUILDDIR}/winico-master/Winico${subst .,,$(WINICO_VERSION)}.dll 
${BUILDDIR}/winico-master/Winico${subst .,,$(WINICO_VERSION)}.dll :
	@cd ${BUILDDIR}/winico-master && make MPEXPAND="$(PREFIX)/bin/tclsh86.exe $(BUILDDIR)/tcllib-$(TCLLIB_VERSION)/modules/doctools/mpexpand" && strip *.dll

install-winico: build-winico ${PREFIX}/lib/Winico${WINICO_VERSION}
${PREFIX}/lib/Winico${WINICO_VERSION}:
	@cd ${BUILDDIR}/winico-master && make pkgIndex.tcl && make install-binaries
	@cd ${BUILDDIR}/winico-master && cp license.terms $(PREFIX)/lib/Winico${WINICO_VERSION}

uninstall-winico:
	@-cd ${PREFIX} && rm -rf lib/Winico${WINICO_VERSION}

clean-winico:
	@-cd ${BUILDDIR}/winico-master && make clean

distclean-winico:
	@-rm -rf ${BUILDDIR}/winico-master
	
# snack
fetch-snack: ${DISTFILES} ${DISTFILES}/snack$(SNACK_VERSION).tar.gz ${DISTFILES}/ming.zip
${DISTFILES}/snack$(SNACK_VERSION).tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://www.speech.kth.se/snack/dist/snack${SNACK_VERSION}.tar.gz"
${DISTFILES}/ming.zip:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://people.montana.com/%7Ebowman/Software/ming.zip"
			
extract-snack: fetch-snack ${BUILDDIR} ${BUILDDIR}/snack${SNACK_VERSION}/win/i386-mingw32
${BUILDDIR}/snack${SNACK_VERSION}/win/i386-mingw32:
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/snack$(SNACK_VERSION).tar.gz.md5 || exit 1
	@cd ${DISTFILES} && md5sum -c ${MD5SUMS}/ming.zip.md5 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/snack$(SNACK_VERSION).tar.gz
	@-cd ${BUILDDIR}/snack${SNACK_VERSION} && patch -p0 < $(PATCHDIR)/snack.patch
	@-cd ${BUILDDIR}/snack$(SNACK_VERSION)/win && $(UNZIP) ${DISTFILES}/ming.zip
	
configure-snack: install-tk extract-snack ${BUILDDIR}/snack${SNACK_VERSION}/win/Makefile
${BUILDDIR}/snack${SNACK_VERSION}/win/Makefile:
	@cd ${BUILDDIR}/snack${SNACK_VERSION}/win && \
		CFLAGS="$(CFLAGS) -I./i386-mingw32/include" \
		LDFLAGS="$(LDFLAGS) -L./i386-mingw32/lib" \
		./configure --prefix=${PREFIX} --enable-threads --enable-shared --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-snack: configure-snack ${BUILDDIR}/snack${SNACK_VERSION}/win/libsnack.dll 
${BUILDDIR}/snack${SNACK_VERSION}/win/libsnack.dll :
	@cd ${BUILDDIR}/snack${SNACK_VERSION}/win && make && strip *.dll

install-snack: build-snack ${PREFIX}/lib/snack${SNACK_SHORT}
${PREFIX}/lib/snack$(SNACK_SHORT):
	@cd $(BUILDDIR)/snack$(SNACK_VERSION)/win && make install
	@cd $(BUILDDIR)/snack$(SNACK_VERSION) && cp -f doc/tcl-man.html $(PREFIX)/lib/snack$(SNACK_SHORT)
	
uninstall-snack:
	@-cd ${PREFIX} && rm -rf lib/snack$(SNACK_SHORT)

clean-snack:
	@-cd ${BUILDDIR}/snack${SNACK_VERSION} && make clean

distclean-snack:
	@-rm -rf ${BUILDDIR}/snack${SNACK_VERSION}
	