# Tkabber-pack defs
# based on WinTclTk defs
# Copyright (c) 2006-2008 Martin Matuska
# Copyright (c) 2014 Vitaly Takmazov
#
all: install
install: extract-tkabber install-tcl install-tk install-memchan install-tls install-tkimg install-tcludp install-tclvfs install-tcllib install-bwidget ${INSTALL_WIN32_DEPS} install-snack install-tkcon
uninstall: uninstall-tcl uninstall-tk uninstall-memchan uninstall-tls uninstall-tkimg uninstall-openssl uninstall-tcludp uninstall-tclvfs uninstall-tcllib uninstall-bwidget ${UNINSTALL_WIN32_DEPS} uninstall-snack uninstall-tkcon
clean: clean-tcl clean-tk clean-memchan clean-tls clean-tkimg clean-openssl clean-tcludp clean-tclvfs clean-tcllib clean-bwidget clean-snack clean-tkcon ${CLEAN_WIN32_DEPS}
distclean: distclean-tcl distclean-tk distclean-memchan distclean-tls distclean-tkimg distclean-openssl distclean-tcludp distclean-tclvfs distclean-tcllib distclean-bwidget ${DISTCLEAN_WIN32_DEPS} distclean-snack distclean-tkcon

# directories
${DISTFILES}:
	@[ -d "${DISTFILES}" ] || mkdir -p ${DISTFILES}

${BUILDDIR}:
	@[ -d "${BUILDDIR}" ] || mkdir -p ${BUILDDIR}

# tcl	
fetch-tcl: ${DISTFILES} ${DISTFILES}/tcl${TCLTK_VERSION}-src.tar.gz 
${DISTFILES}/tcl${TCLTK_VERSION}-src.tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcl/tcl${TCLTK_VERSION}-src.tar.gz"

extract-tcl: fetch-tcl ${BUILDDIR} ${BUILDDIR}/tcl${TCLTK_VERSION} 
${BUILDDIR}/tcl${TCLTK_VERSION}:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tcl${TCLTK_VERSION}-src.tar.gz.sha256 || exit 1
	@cd ${BUILDDIR} && tar xfz ${DISTFILES}/tcl${TCLTK_VERSION}-src.tar.gz
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION} && patch -p0 < ${PATCHDIR}/tcl.patch

configure-tcl: extract-tcl ${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR}/Makefile
${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR}/Makefile:
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR} && autoreconf -ifv && ./configure --prefix=${PREFIX} --enable-shared --enable-threads $(WIN64_CFLAGS)

build-tcl: configure-tcl ${BUILDDIR} ${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR}/tclsh86${EXEEXT}
${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR}/tclsh86${EXEEXT}:
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR} && make

install-tcl: build-tcl ${PREFIX}/lib/tclConfig.sh
${PREFIX}/lib/tclConfig.sh:
	@cd ${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR} && make install

uninstall-tcl:
	@-cd ${PREFIX}/bin && rm tcl*.dll tclsh*.exe
	@-cd ${PREFIX}/lib && rm -rf dde1.2 libtclstub*.a tcl* libtcl*.a reg1.1 tclConfig.sh
	@-cd ${PREFIX}/include && rm tclDecls.h tcl.h tclPlatDecls.h
	
clean-tcl:
	@-cd ${BUILDDIR}/tcl${TCLTK_VERSION}/${TCL_MAKE_DIR} && make clean

distclean-tcl:
	@-rm -rf ${BUILDDIR}/tcl${TCLTK_VERSION}

# tk
fetch-tk: ${DISTFILES} ${DISTFILES}/tk${TCLTK_VERSION}-src.tar.gz 
${DISTFILES}/tk${TCLTK_VERSION}-src.tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcl/tk${TCLTK_VERSION}-src.tar.gz"

extract-tk: fetch-tk ${BUILDDIR} ${BUILDDIR}/tk${TCLTK_VERSION} 
${BUILDDIR}/tk${TCLTK_VERSION}:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tk${TCLTK_VERSION}-src.tar.gz.sha256 || exit 1
	@cd ${BUILDDIR} && tar xfz ${DISTFILES}/tk${TCLTK_VERSION}-src.tar.gz
	@cd ${BUILDDIR}/tk${TCLTK_VERSION} && patch -p0 < ${PATCHDIR}/tk.patch

configure-tk: install-tcl extract-tk ${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR}/Makefile
${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR}/Makefile:
	@cd ${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR} && autoreconf -ifv && ./configure --prefix=${PREFIX} --enable-shared --enable-threads $(OSX_CFLAGS)

build-tk: configure-tk ${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR}/wish86${EXEEXT}
${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR}/wish86${EXEEXT}:
	@cd ${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR} && make

install-tk: build-tk ${PREFIX}/lib/tkConfig.sh 
${PREFIX}/lib/tkConfig.sh:
	@cd ${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR} && make install
	
uninstall-tk:
	@-cd ${PREFIX}/bin && rm tk*.dll wish*.exe
	@-cd ${PREFIX}/lib && rm -rf tk* libtk*.a libtkstub*.a tkConfig.sh
	@-cd ${PREFIX}/include && rm -rf X11 tk.h tkDecls.h tkIntXlibDecls.h tkPlatDecls.h 

clean-tk:
	@-cd ${BUILDDIR}/tk${TCLTK_VERSION}/${TCL_MAKE_DIR} && make clean

distclean-tk:
	@-rm -rf ${BUILDDIR}/tk${TCLTK_VERSION}

# tkimg
fetch-tkimg: ${DISTFILES} ${DISTFILES}/tkimg${TKIMG_VERSION}.tar.gz
${DISTFILES}/tkimg${TKIMG_VERSION}.tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/tkimg/${TKIMG_SHORT}/tkimg${TKIMG_VERSION}.tar.gz"

extract-tkimg: fetch-tkimg ${BUILDDIR} ${BUILDDIR}/tkimg${TKIMG_SHORT}
${BUILDDIR}/tkimg${TKIMG_SHORT}:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tkimg${TKIMG_VERSION}.tar.gz.sha256 || exit 1
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
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && make

install-tkimg: build-tkimg ${PREFIX}/lib/Img${TKIMG_VERSION}
${PREFIX}/lib/Img${TKIMG_VERSION}: 
	@mkdir -p ${PREFIX}/lib/Img${TKIMG_VERSION}/doc
	@cd ${BUILDDIR}/tkimg${TKIMG_SHORT} && make DTPLITE="$(PREFIX)/bin/tclsh86${EXEEXT} $(BUILDDIR)/tcllib-$(TCLLIB_VERSION)/apps/dtplite" install
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
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -o tls${TLS_VERSION}.tar.gz "https://core.tcl-lang.org/tcltls/uv/tcltls-${TLS_VERSION}.tar.gz"

extract-tls: fetch-tls ${BUILDDIR} ${BUILDDIR}/tcltls-${TLS_VERSION}
${BUILDDIR}/tcltls-${TLS_VERSION}:
#	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tls${TLS_VERSION}.tar.gz.sha256 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/tls${TLS_VERSION}.tar.gz
	@cd ${BUILDDIR}/tcltls-${TLS_VERSION} && patch -p0 < ${PATCHDIR}/tls.patch

configure-tls: install-openssl extract-tls ${BUILDDIR}/tcltls-${TLS_VERSION}/Makefile
${BUILDDIR}/tcltls-${TLS_VERSION}/Makefile:
	@cd ${BUILDDIR}/tcltls-${TLS_VERSION} && autoreconf -ifv && LIBS="${TLS_WIN32_LIBS}" ./configure --enable-hardening=false --enable-static-ssl --prefix=${PREFIX} --with-tcl=${PREFIX}/lib --with-ssl=libressl --with-openssl-dir=${PREFIX}

build-tls: configure-tls ${BUILDDIR}/tcltls-${TLS_VERSION}/tcltls.dll 
${BUILDDIR}/tcltls-${TLS_VERSION}/tcltls.dll:
	@cd ${BUILDDIR}/tcltls-${TLS_VERSION} && make

install-tls: build-tls ${PREFIX}/lib/tcltls${TLS_VERSION}
${PREFIX}/lib/tcltls${TLS_VERSION}: 
	@mkdir -p ${PREFIX}/lib/tcltls${TLS_VERSION}
	@cd ${BUILDDIR}/tcltls-${TLS_VERSION} && make install
	@cd ${BUILDDIR}/tcltls-${TLS_VERSION} && cp license.terms tls.htm ${PREFIX}/lib/tcltls${TLS_VERSION} 

uninstall-tls:
	@-cd ${PREFIX} && rm -rf lib/tcltls${TLS_VERSION} include/tls.h

clean-tls:
	@-cd ${BUILDDIR}/tcltls-${TLS_VERSION} && make clean

distclean-tls:
	@-rm -rf ${BUILDDIR}/tcltls-${TLS_VERSION}

# tcllib
fetch-tcllib: ${DISTFILES} ${DISTFILES}/tcllib-${TCLLIB_VERSION}.tar.gz 
${DISTFILES}/tcllib-${TCLLIB_VERSION}.tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} "https://core.tcl-lang.org/tcllib/uv/tcllib-${TCLLIB_VERSION}.tar.gz" -o "tcllib-${TCLLIB_VERSION}.tar.gz"

extract-tcllib: fetch-tcllib ${BUILDDIR} ${BUILDDIR}/tcllib-${TCLLIB_VERSION} 
${BUILDDIR}/tcllib-${TCLLIB_VERSION}:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tcllib-${TCLLIB_VERSION}.tar.gz.sha256 || exit 1
	@cd ${BUILDDIR} && mkdir tcllib-${TCLLIB_VERSION} && tar --strip-components=1 -xf ${DISTFILES}/tcllib-${TCLLIB_VERSION}.tar.gz -C tcllib-${TCLLIB_VERSION}

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
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcllib/bwidget-${BWIDGET_VERSION}.tar.gz"

extract-bwidget: fetch-bwidget ${BUILDDIR} ${BUILDDIR}/bwidget-${BWIDGET_VERSION} 
${BUILDDIR}/bwidget-${BWIDGET_VERSION}:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/bwidget-${BWIDGET_VERSION}.tar.gz.sha256 || exit 1
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

# tcludp
fetch-tcludp: $(DISTFILES) $(DISTFILES)/tcludp-$(TCLUDP_VERSION).tar.gz 
$(DISTFILES)/tcludp-$(TCLUDP_VERSION).tar.gz:
	@cd $(DISTFILES) && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/tcludp/tcludp-$(TCLUDP_VERSION).tar.gz"

extract-tcludp: fetch-tcludp $(BUILDDIR) $(BUILDDIR)/tcludp
$(BUILDDIR)/tcludp:
	@cd $(DISTFILES) && shasum -a 256 -c $(MD5SUMS)/tcludp-$(TCLUDP_VERSION).tar.gz.sha256 || exit 1
	@-cd $(BUILDDIR) && tar xfz $(DISTFILES)/tcludp-$(TCLUDP_VERSION).tar.gz

configure-tcludp: extract-tcludp install-tcl $(BUILDDIR)/tcludp/Makefile
$(BUILDDIR)/tcludp/Makefile:
	@cd $(BUILDDIR)/tcludp && ./configure --prefix=${PREFIX} --enable-threads --enable-shared

build-tcludp: configure-tcludp $(BUILDDIR)/tcludp/udp$(TCLUDP_LIBVER).dll 
$(BUILDDIR)/tcludp/udp$(TCLUDP_LIBVER).dll:
	@cd $(BUILDDIR)/tcludp && make

install-tcludp: build-tcludp $(PREFIX)/lib/udp$(TCLUDP_VERSION)
$(PREFIX)/lib/udp$(TCLUDP_VERSION): 
	@cd $(BUILDDIR)/tcludp && make install
	@cd ${BUILDDIR}/tcludp && cp license.terms $(PREFIX)/lib/udp${TCLUDP_VERSION}

uninstall-tcludp:
	@-cd $(PREFIX)/lib && rm -rf udp$(TCLUDP_VERSION)
	@-cd $(PREFIX) && rm -rf man

clean-tcludp:
	@-cd $(BUILDDIR)/tcludp && make clean

distclean-tcludp:
	@-rm -rf $(BUILDDIR)/tcludp	
	
# tclvfs
fetch-tclvfs: $(DISTFILES) $(DISTFILES)/tclvfs-$(TCLVFS_VERSION).tar.gz 
$(DISTFILES)/tclvfs-$(TCLVFS_VERSION).tar.gz :
	@cd $(DISTFILES) && ${CURL} ${CURL_FLAGS} -o tclvfs-$(TCLVFS_VERSION).tar.gz "https://core.tcl-lang.org/tclvfs/tarball/b5e463e712/tclvfs-b5e463e712.tar.gz"

extract-tclvfs: fetch-tclvfs $(BUILDDIR) $(BUILDDIR)/tclvfs-b5e463e712
$(BUILDDIR)/tclvfs-b5e463e712:
#	@cd $(DISTFILES) && shasum -a 256 -c $(MD5SUMS)/tclvfs-$(TCLVFS_VERSION).tar.gz.sha256 || exit 1
	@-cd $(BUILDDIR) && tar xfz $(DISTFILES)/tclvfs-$(TCLVFS_VERSION).tar.gz
	@cd $(BUILDDIR)/tclvfs-b5e463e712 && patch -p0 < $(PATCHDIR)/tclvfs.patch

configure-tclvfs: extract-tclvfs install-tcl $(BUILDDIR)/tclvfs-b5e463e712/Makefile
$(BUILDDIR)/tclvfs-b5e463e712/Makefile:
	@cd $(BUILDDIR)/tclvfs-b5e463e712 && autoconf && ./configure --prefix=${PREFIX} $(WIN64_CFLAGS)

build-tclvfs: configure-tclvfs $(BUILDDIR)/tclvfs-b5e463e712/vfs$(TCLVFS_LIBVER).dll 
$(BUILDDIR)/tclvfs-b5e463e712/vfs$(TCLVFS_LIBVER).dll:
	@cd $(BUILDDIR)/tclvfs-b5e463e712 && make

install-tclvfs: build-tclvfs $(PREFIX)/lib/vfs$(TCLVFS_VERSION)
$(PREFIX)/lib/vfs$(TCLVFS_VERSION): 
	@cd $(BUILDDIR)/tclvfs-b5e463e712 && make install

uninstall-tclvfs:
	@-cd $(PREFIX)/lib && rm -rf vfs$(TCLVFS_VERSION)
	@-cd $(PREFIX) && rm -rf man

clean-tclvfs:
	@-cd $(BUILDDIR)/tclvfs-b5e463e712 && make clean

distclean-tclvfs:
	@-rm -rf $(BUILDDIR)/tclvfs-b5e463e712

# memchan
fetch-memchan: $(DISTFILES)/Memchan$(MEMCHAN_VERSION).tar.gz
$(DISTFILES)/Memchan$(MEMCHAN_VERSION).tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/memchan/$(MEMCHAN_VERSION)/Memchan$(MEMCHAN_VERSION).tar.gz"
		
extract-memchan: fetch-memchan $(BUILDDIR) $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)
$(BUILDDIR)/Memchan$(MEMCHAN_VERSION):
	@cd ${DISTFILES} && shasum -a 256 -c $(MD5SUMS)/Memchan$(MEMCHAN_VERSION).tar.gz.sha256 || exit 1
	@cd $(BUILDDIR) && tar xfz $(DISTFILES)/Memchan$(MEMCHAN_VERSION).tar.gz

configure-memchan: extract-memchan install-tcl install-tcllib $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Makefile
$(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Makefile:
	@cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && ./configure --prefix=$(PREFIX) --enable-threads --enable-shared  --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-memchan: configure-memchan $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Memchan${MEMCHAN_LIBVER}.dll 
$(BUILDDIR)/Memchan$(MEMCHAN_VERSION)/Memchan${MEMCHAN_LIBVER}.dll :
	@cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && make

install-memchan: build-memchan $(PREFIX)/lib/Memchan$(MEMCHAN_VERSION)/pkgIndex.tcl
$(PREFIX)/lib/Memchan$(MEMCHAN_VERSION)/pkgIndex.tcl:
	@cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && make install
	
uninstall-memchan:
	@-cd $(PREFIX)/lib && rm -rf Memchan${MEMCHAN_VERSION}

clean-memchan:
	@-cd $(BUILDDIR)/Memchan$(MEMCHAN_VERSION) && make clean

distclean-memchan:
	@-rm -rf $(BUILDDIR)/Memchan$(MEMCHAN_VERSION)	

# winico
fetch-winico: ${DISTFILES} ${DISTFILES}/winico${subst .,,$(WINICO_VERSION)}cvs.tar.gz
${DISTFILES}/winico${subst .,,$(WINICO_VERSION)}cvs.tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -o winico${subst .,,$(WINICO_VERSION)}cvs.tar.gz "https://github.com/vitalyster/winico/archive/master.tar.gz"

extract-winico: fetch-winico ${BUILDDIR} ${BUILDDIR}/winico-master
${BUILDDIR}/winico-master:
	@cd ${DISTFILES} #&& shasum -a 256 -c ${MD5SUMS}/winico${subst .,,$(WINICO_VERSION)}cvs.zip.sha256 || exit 1
	@cd ${BUILDDIR} && tar xf ${DISTFILES}/winico${subst .,,$(WINICO_VERSION)}cvs.tar.gz
	@-cd $(BUILDDIR)/winico-master && patch -p1 < $(PATCHDIR)/winico.patch

configure-winico: install-tk build-tcllib extract-winico ${BUILDDIR}/winico-master/Makefile
${BUILDDIR}/winico-master/Makefile:
	@cd ${BUILDDIR}/winico-master && ./configure --prefix=${PREFIX} --enable-threads --enable-shared --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-winico: configure-winico ${BUILDDIR}/winico-master/Winico${subst .,,$(WINICO_VERSION)}.dll
${BUILDDIR}/winico-master/Winico${subst .,,$(WINICO_VERSION)}.dll :
	@cd ${BUILDDIR}/winico-master && make MPEXPAND="$(PREFIX)/bin/tclsh86${EXEEXT} $(BUILDDIR)/tcllib-$(TCLLIB_VERSION)/modules/doctools/mpexpand"

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
fetch-snack: ${DISTFILES} ${DISTFILES}/snack$(SNACK_VERSION).tar.gz
${DISTFILES}/snack$(SNACK_VERSION).tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://www.speech.kth.se/snack/dist/snack${SNACK_VERSION}.tar.gz"
			
extract-snack: fetch-snack ${BUILDDIR} ${BUILDDIR}/snack${SNACK_VERSION}
${BUILDDIR}/snack${SNACK_VERSION}:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/snack$(SNACK_VERSION).tar.gz.sha256 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/snack$(SNACK_VERSION).tar.gz
	@-cd ${BUILDDIR}/snack${SNACK_VERSION} && patch -p0 < $(PATCHDIR)/snack.patch
	
configure-snack: install-tk extract-snack ${BUILDDIR}/snack${SNACK_VERSION}/${TCL_MAKE_DIR}/Makefile
${BUILDDIR}/snack${SNACK_VERSION}/${TCL_MAKE_DIR}/Makefile:
	@cd ${BUILDDIR}/snack${SNACK_VERSION}/${TCL_MAKE_DIR} && \
		./configure --prefix=${PREFIX} --with-tcl=${PREFIX}/lib --with-tk=${PREFIX}/lib

build-snack: configure-snack ${BUILDDIR}/snack${SNACK_VERSION}/${TCL_MAKE_DIR}/libsnack${shlibext}
${BUILDDIR}/snack${SNACK_VERSION}/${TCL_MAKE_DIR}/libsnack${shlibext} :
	@cd ${BUILDDIR}/snack${SNACK_VERSION}/${TCL_MAKE_DIR} && make

install-snack: build-snack ${PREFIX}/lib/snack${SNACK_SHORT}
${PREFIX}/lib/snack$(SNACK_SHORT):
	@cd $(BUILDDIR)/snack$(SNACK_VERSION)/${TCL_MAKE_DIR} && make install DESTDIR=${PREFIX}
	@cd $(BUILDDIR)/snack$(SNACK_VERSION) && cp -f doc/tcl-man.html $(PREFIX)/lib/snack$(SNACK_SHORT)
	
uninstall-snack:
	@-cd ${PREFIX} && rm -rf lib/snack$(SNACK_SHORT)

clean-snack:
	@-cd ${BUILDDIR}/snack${SNACK_VERSION} && make clean

distclean-snack:
	@-rm -rf ${BUILDDIR}/snack${SNACK_VERSION}

fetch-windns: ${DISTFILES} ${DISTFILES}/windns-$(WINDNS_VERSION).tar.gz
${DISTFILES}/windns-$(WINDNS_VERSION).tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} "https://github.com/vitalyster/windns/archive/v${WINDNS_VERSION}.tar.gz" -o windns-${WINDNS_VERSION}.tar.gz

extract-windns: fetch-windns ${BUILDDIR} ${BUILDDIR}/windns-${WINDNS_VERSION}/configure.ac
${BUILDDIR}/windns-${WINDNS_VERSION}/configure.ac:
	@cd ${DISTFILES} && shasum -a 256 -c -c ${MD5SUMS}/windns-$(WINDNS_VERSION).tar.gz.sha256 || exit 1
	@-cd ${BUILDDIR} && tar xfz ${DISTFILES}/windns-$(WINDNS_VERSION).tar.gz

configure-windns: install-tcl extract-windns ${BUILDDIR}/windns-${WINDNS_VERSION}/Makefile
${BUILDDIR}/windns-${WINDNS_VERSION}/Makefile:
	@cd ${BUILDDIR}/windns-${WINDNS_VERSION} && \
		autoreconf -if -I tclconfig && \
		./configure --prefix=${PREFIX} --with-tcl=${PREFIX}/lib

build-windns: configure-windns ${BUILDDIR}/windns-${WINDNS_VERSION}/windns${WINDNS_LIBVER}.dll
${BUILDDIR}/windns-${WINDNS_VERSION}/windns${WINDNS_LIBVER}.dll:
	@cd ${BUILDDIR}/windns-${WINDNS_VERSION} && make

install-windns: build-windns extract-tkabber ${PREFIX}/lib/windns${WINDNS_VERSION} ${PREFIX}/tkabber/plugins/windows/windns.tcl
${PREFIX}/lib/windns${WINDNS_VERSION}:
	@cd ${BUILDDIR}/windns-${WINDNS_VERSION} && make install-binaries
${PREFIX}/tkabber/plugins/windows/windns.tcl:
	@cd ${BUILDDIR}/windns-${WINDNS_VERSION} && cp windns.tcl ${ROOTDIR}/tkabber/plugins/windows/windns.tcl

uninstall-windns:
	@cd ${PREFIX} && rm -rf lib/windns$(WINDNS_VERSION)

clean-windns:
	@cd {BUILDDIR}/windns-{$WINDNS_VERSION} && make clean

distclean-windns:
	@rm -rf {BUILDDIR}/windns-{$WINDNS_VERSION}
