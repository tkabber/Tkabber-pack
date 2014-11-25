# Tkabber-pack common defs
# based on WinTclTk common defs
# Copyright (c) 2006-2008 Martin Matuska
# Copyright (c) 2014 Vitaly Takmazov
#
COMMONBUILD?=	$(SRCDIR)/build_c

$(COMMONBUILD):
	@mkdir -p $(COMMONBUILD)

# tkabber
fetch-tkabber: ${DISTFILES} ${DISTFILES}/tkabber-$(TKABBER_VERSION).tar.xz ${DISTFILES}/tkabber-plugins-$(TKABBER_VERSION).tar.xz
${DISTFILES}/tkabber-$(TKABBER_VERSION).tar.xz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://files.jabber.ru/tkabber/tkabber-${TKABBER_VERSION}.tar.xz"
${DISTFILES}/tkabber-plugins-$(TKABBER_VERSION).tar.xz: 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://files.jabber.ru/tkabber/tkabber-plugins-${TKABBER_VERSION}.tar.xz"

extract-tkabber: fetch-tkabber ${ROOTDIR}/tkabber ${ROOTDIR}/tkabber-plugins ${ROOTDIR}/tkabber/plugins/general/challenge.tcl
${ROOTDIR}/tkabber:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tkabber-${TKABBER_VERSION}.tar.xz.sha256 || exit 1
	@cd ${ROOTDIR} && tar --transform 's/-${TKABBER_VERSION}//' -xJvf ${DISTFILES}/tkabber-${TKABBER_VERSION}.tar.xz  >/dev/null 2>&1
${ROOTDIR}/tkabber-plugins:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tkabber-plugins-${TKABBER_VERSION}.tar.xz.sha256 || exit 1
	@cd ${ROOTDIR} && tar --transform 's/-${TKABBER_VERSION}//' -xJvf ${DISTFILES}/tkabber-plugins-${TKABBER_VERSION}.tar.xz  >/dev/null 2>&1
${ROOTDIR}/tkabber/plugins/general/challenge.tcl:
# upgrading from 0.11.1 may fail without this file
	@touch ${ROOTDIR}/tkabber/plugins/general/challenge.tcl

# openssl
fetch-openssl: ${DISTFILES} ${DISTFILES}/openssl-${OPENSSL_VERSION}.tar.gz 
${DISTFILES}/openssl-${OPENSSL_VERSION}.tar.gz:
	@[ -x "${WGET}" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd ${DISTFILES} && ${WGET} ${WGET_FLAGS} "http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"

extract-openssl: fetch-openssl $(COMMONBUILD) $(COMMONBUILD)/openssl-${OPENSSL_VERSION}
$(COMMONBUILD)/openssl-${OPENSSL_VERSION}:
	@cd ${DISTFILES} && sha1sum -c ${MD5SUMS}/openssl-${OPENSSL_VERSION}.tar.gz.sha1 || exit 1
	@-cd $(COMMONBUILD) && tar xfz ${DISTFILES}/openssl-${OPENSSL_VERSION}.tar.gz >/dev/null 2>&1

configure-openssl: extract-openssl $(COMMONBUILD)/openssl-${OPENSSL_VERSION}/configure.done
$(COMMONBUILD)/openssl-${OPENSSL_VERSION}/configure.done:
	@[ -x "${PERL}" ] || ( echo "$(MESSAGE_OPENSSL_PERL)"; exit 1 ) 
	@cd $(COMMONBUILD)/openssl-${OPENSSL_VERSION} && ./Configure --prefix=${PREFIX} ${OPENSSL_TARGET} no-shared enable-static-engine threads && touch configure.done 

build-openssl: configure-openssl $(COMMONBUILD)/openssl-$(OPENSSL_VERSION)/libcrypto.a 
$(COMMONBUILD)/openssl-$(OPENSSL_VERSION)/libcrypto.a:
	@cd $(COMMONBUILD)/openssl-${OPENSSL_VERSION} && make

install-openssl: build-openssl ${PREFIX}/lib/libcrypto.a
${PREFIX}/lib/libcrypto.a: 
	@cd $(COMMONBUILD)/openssl-${OPENSSL_VERSION} && make install MKDIR="mkdir -p" INSTALLTOP="$(PREFIX)"
	@cp $(COMMONBUILD)/openssl-${OPENSSL_VERSION}/LICENSE ${PREFIX}/lib/OpenSSL.license

uninstall-openssl:
	@-cd ${PREFIX} && rm -rf bin/openssl.exe bin/libeay32.dll bin/ssleay32.dll include/openssl lib/libssl*.a lib/libcrypto*.a 

clean-openssl:
	@-cd $(COMMONBUILD)/openssl-${OPENSSL_VERSION} && make clean

distclean-openssl:
	@-rm -rf $(COMMONBUILD)/openssl-${OPENSSL_VERSION}

# tkcon
fetch-tkcon: $(DISTFILES) $(DISTFILES)/tkcon-$(TKCON_VERSION).tar.gz
$(DISTFILES)/tkcon-$(TKCON_VERSION).tar.gz:
	@[ -x "$(WGET)" ] || ( echo "$(MESSAGE_WGET)"; exit 1 ) 
	@cd $(DISTFILES) && $(WGET) "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/tkcon/tkcon-${TKCON_VERSION}.tar.gz"

extract-tkcon: fetch-tkcon $(COMMONBUILD) $(COMMONBUILD)/tkcon-$(TKCON_VERSION)
$(COMMONBUILD)/tkcon-$(TKCON_VERSION):
	@cd $(DISTFILES) && md5sum -c $(MD5SUMS)/tkcon-$(TKCON_VERSION).tar.gz.md5 || exit 1
	@cd $(COMMONBUILD) && tar xfz $(DISTFILES)/tkcon-$(TKCON_VERSION).tar.gz
	@cd $(COMMONBUILD)/tkcon-$(TKCON_VERSION) && patch -p0 < $(PATCHDIR)/tkcon.patch

configure-tkcon: extract-tkcon
build-tkcon: configure-tkcon

install-tkcon: build-tkcon $(PREFIX)/lib/tkcon$(TKCON_VERSION)/pkgIndex.tcl
$(PREFIX)/lib/tkcon$(TKCON_VERSION)/pkgIndex.tcl:
	@mkdir -p $(PREFIX)/lib/tkcon$(TKCON_VERSION)
	@cd $(COMMONBUILD)/tkcon-$(TKCON_VERSION) && cp -Rp tkcon.tcl pkgIndex.tcl README.txt Changelog docs $(PREFIX)/lib/tkcon$(TKCON_VERSION)

uninstall-tkcon:
	@-cd $(PREFIX)/lib && rm -rf tkcon$(TKCON_VERSION)

clean-tkcon:

distclean-tkcon:
	@-rm -rf $(COMMONBUILD)/tkcon-$(TKCON_VERSION)
