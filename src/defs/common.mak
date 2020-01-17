# Tkabber-pack common defs
# based on WinTclTk common defs
# Copyright (c) 2006-2008 Martin Matuska
# Copyright (c) 2014 Vitaly Takmazov
#
COMMONBUILD?=	$(BUILDDIR)

# tkabber
fetch-tkabber: ${DISTFILES} ${DISTFILES}/tkabber-$(TKABBER_VERSION).tar.xz ${DISTFILES}/tkabber-plugins-$(TKABBER_VERSION).tar.xz
${DISTFILES}/tkabber-$(TKABBER_VERSION).tar.xz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "http://files.jabber.ru/tkabber/tkabber-${TKABBER_VERSION}.tar.xz"
${DISTFILES}/tkabber-plugins-$(TKABBER_VERSION).tar.xz: 
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O  "http://files.jabber.ru/tkabber/tkabber-plugins-${TKABBER_VERSION}.tar.xz"

extract-tkabber: fetch-tkabber ${ROOTDIR}/tkabber ${ROOTDIR}/tkabber-plugins ${ROOTDIR}/tkabber/plugins/general/challenge.tcl
${ROOTDIR}/tkabber:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tkabber-${TKABBER_VERSION}.tar.xz.sha256 || exit 1
	@cd ${ROOTDIR} && mkdir tkabber && tar --strip-components=1 -xJvf ${DISTFILES}/tkabber-${TKABBER_VERSION}.tar.xz -C tkabber  >/dev/null 2>&1
${ROOTDIR}/tkabber-plugins:
	@cd ${DISTFILES} && shasum -a 256 -c ${MD5SUMS}/tkabber-plugins-${TKABBER_VERSION}.tar.xz.sha256 || exit 1
	@cd ${ROOTDIR} && mkdir tkabber-plugins && tar --strip-components=1 -xJvf ${DISTFILES}/tkabber-plugins-${TKABBER_VERSION}.tar.xz -C tkabber-plugins  >/dev/null 2>&1
${ROOTDIR}/tkabber/plugins/general/challenge.tcl:
# upgrading from 0.11.1 may fail without this file
	@touch ${ROOTDIR}/tkabber/plugins/general/challenge.tcl

# openssl
fetch-openssl: ${DISTFILES} ${DISTFILES}/libressl-${LIBRESSL_VERSION}.tar.gz 
${DISTFILES}/libressl-${LIBRESSL_VERSION}.tar.gz:
	@cd ${DISTFILES} && ${CURL} ${CURL_FLAGS} -O "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz"

extract-openssl: fetch-openssl $(COMMONBUILD) $(COMMONBUILD)/libressl-${LIBRESSL_VERSION}
$(COMMONBUILD)/libressl-${LIBRESSL_VERSION}:
	@cd ${DISTFILES} && shasum -c ${MD5SUMS}/libressl-${LIBRESSL_VERSION}.tar.gz.sha1 || exit 1
	@-cd $(COMMONBUILD) && tar xfz ${DISTFILES}/libressl-${LIBRESSL_VERSION}.tar.gz >/dev/null 2>&1
	@cd $(COMMONBUILD)/libressl-${LIBRESSL_VERSION} && patch -p0 < $(PATCHDIR)/libressl.patch && autoreconf -ifv

configure-openssl: extract-openssl $(COMMONBUILD)/libressl-${LIBRESSL_VERSION}/configure.done
$(COMMONBUILD)/libressl-${LIBRESSL_VERSION}/configure.done:
	@cd $(COMMONBUILD)/libressl-${LIBRESSL_VERSION} && cmake . -G "MSYS Makefiles" -DCMAKE_INSTALL_PREFIX=${PREFIX} -DLIBRESSL_APPS=OFF -DLIBRESSL_TESTS=OFF && touch configure.done 

build-openssl: configure-openssl $(COMMONBUILD)/libressl-$(LIBRESSL_VERSION)/crypto/libcrypto.a 
$(COMMONBUILD)/libressl-$(LIBRESSL_VERSION)/crypto/libcrypto.a:
	@cd $(COMMONBUILD)/libressl-${LIBRESSL_VERSION} && make

install-openssl: build-openssl ${PREFIX}/lib/libcrypto.a
${PREFIX}/lib/libcrypto.a: 
	@cd $(COMMONBUILD)/libressl-${LIBRESSL_VERSION} && make install MKDIR="mkdir -p" INSTALLTOP="$(PREFIX)"
	@cp $(COMMONBUILD)/libressl-${LIBRESSL_VERSION}/COPYING ${PREFIX}/lib/LibreSSL.license

uninstall-openssl:
	@-cd ${PREFIX} && rm -rf bin/openssl.exe bin/libeay32.dll bin/ssleay32.dll include/openssl lib/libssl*.a lib/libcrypto*.a 

clean-openssl:
	@-cd $(COMMONBUILD)/libressl-${LIBRESSL_VERSION} && make clean

distclean-openssl:
	@-rm -rf $(COMMONBUILD)/libressl-${LIBRESSL_VERSION}

# tkcon
fetch-tkcon: $(DISTFILES) $(DISTFILES)/tkcon-$(TKCON_VERSION).tar.gz
$(DISTFILES)/tkcon-$(TKCON_VERSION).tar.gz:
	@cd $(DISTFILES) && ${CURL} ${CURL_FLAGS} -O "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/tkcon/tkcon-${TKCON_VERSION}.tar.gz"

extract-tkcon: fetch-tkcon $(COMMONBUILD) $(COMMONBUILD)/tkcon-$(TKCON_VERSION)
$(COMMONBUILD)/tkcon-$(TKCON_VERSION):
	@cd $(DISTFILES) && shasum -a 256 -c $(MD5SUMS)/tkcon-$(TKCON_VERSION).tar.gz.sha256 || exit 1
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
