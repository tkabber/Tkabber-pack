# Tkabber-pack Make defs
# based on WinTclTk Make defs
# Copyright (c) 2006-2008 Martin Matuska
# Copyright (c) 2014 Vitaly Takmazov
#
TKABBER_VERSION=	1.1
TCLTK_VERSION=		8.6.1
TCLLIB_VERSION=		1.15
BWIDGET_VERSION=	1.9.7
TWAPI_VERSION=		2.0.12
TLS_VERSION=		1.6.3
TKIMG_VERSION=		1.4.2
TDOM_VERSION=		0.8.3
MEMCHAN_VERSION=	2.3
TRF_VERSION=		2.1.3
TCLUDP_VERSION=		1.0.8
TCLVFS_VERSION=		1.4.2
TKCON_VERSION=		2.5
WINICO_VERSION=		0.6
SNACK_VERSION=		2.2.10

TDOM_LIBVER=		$(subst .,,$(TDOM_VERSION))
TCLVFS_LIBVER=		$(subst .,,$(TCLVFS_VERSION))
TKCON_SOURCE=		20070414
TCLLIB_SHORT=		1.15
SNACK_SHORT=		2.2
TLS_LIBVER=		$(subst .,,$(TLS_VERSION))
TKIMG_LIBVER=		$(subst .,,$(TKIMG_VERSION))
TKIMG_SHORT=		1.4
TCLUDP_LIBVER=		$(subst .,,$(TCLUDP_VERSION))
TRF_LIBVER=		213
MEMCHAN_LIBVER=		23

OPENSSL_VERSION=	1.0.1f
OPENSSL_LIBVER=		1.0.1
ZLIB_VERSION=		1.2.8

ZIP_VERSION=		2.32
ZIP_SHORT=		$(subst .,,$(ZIP_VERSION))
UNZIP_VERSION=		5.52
UNZIP_SHORT=		$(subst .,,$(UNZIP_VERSION))
BZIP2_VERSION=		1.0.4

SOURCEFORGE_MIRROR?=	dfn
GNU_MIRROR?=		ftp.gnu.org/pub/gnu
POSTGRESQL_MIRROR?=	ftp://ftp.postgresql.org/pub/source/v${POSTGRESQL_VERSION}

TOOLSDIR=	$(SRCDIR)/tools

WGET?=		$(shell which wget)
WGET_FLAGS=	--passive-ftp --no-check-certificate
UNZIP=		$(TOOLSDIR)/unzip.exe
ZIP=		$(TOOLSDIR)/zip.exe
PERL?=		$(shell which perl)
UPX?=		$(shell which upx)

DISTFILES?=	$(SRCDIR)/distfiles
MD5SUMS=	$(SRCDIR)/md5sums
PATCHDIR=	$(SRCDIR)/patches

MESSAGE_WGET=		"You require wget to auto-download the sources. See SOURCES.txt for more information."
MESSAGE_OPENSSL_PERL=	"You require perl to configure OpenSSL. See BUILD-MinGW.txt for more information."