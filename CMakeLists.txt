if(MSVC)
	cmake_minimum_required (VERSION 3.16.4)
	cmake_policy(SET CMP0091 NEW)
else()
	cmake_minimum_required (VERSION 3.0)
endif()

project(Tkabber LANGUAGES C)

include(ExternalProject)

if (NOT SOURCEFORGE_MIRROR)
  set(SOURCEFORGE_MIRROR vorboss)
endif()

if (NOT TCLTK_VERSION)
  set(TCLTK_VERSION 8.6.10)
  set(TCL_HASH 5196dbf6638e3df8d5c87b5815c8c2b758496eb6f0e41446596c9a4e638d87ed)
  set(TK_HASH 63df418a859d0a463347f95ded5cd88a3dd3aaa1ceecaeee362194bc30f3e386)
endif()

if (NOT LIBRESSL_VERSION)
  set(LIBRESSL_VERSION 3.2.2)
  set(LIBRESSL_HASH a9d1e1d030b8bcc67bf6428b8c0fff14a5602e2236257b9e3d77acaf12e2a7a1)
endif()

if (NOT TLS_VERSION)
  set(TLS_VERSION 1.7.22)
  set(TLS_HASH e84e2b7a275ec82c4aaa9d1b1f9786dbe4358c815e917539ffe7f667ff4bc3b4)
endif()

if (NOT TCLLIB_VERSION)
  set(TCLLIB_VERSION 1.20)
  set(TCLLIB_HASH e3b097475bcb93c4439df4a088daa59592e1937beee2a2c8495f4f0303125d71)
endif()

if (NOT TKCON_VERSION)
  set(TKCON_VERSION 2.5)
  set(TKCON_HASH 3ff3eb7198b060d2c3bdc195c1f7d8532e63742447179fbb6091a3886bab42a9)
endif()

if (NOT BWIDGET_VERSION)
  set(BWIDGET_VERSION 1.9.14)
  set(BWIDGET_HASH 8e9692140167161877601445e7a5b9da5bb738ce8d08ee99b016629bc784a672)
endif()

if (NOT TCLUDP_VERSION)
  set(TCLUDP_VERSION 1.0.11)
  set(TCLUDP_HASH a8a29d55a718eb90aada643841b3e0715216d27cea2e2df243e184edb780aa9d)
endif()

if (NOT MEMCHAN_VERSION)
  set(MEMCHAN_VERSION 2.3)
  set(MEMCHAN_HASH adaa5952fe532a917372dcdbc873c082656c49b613d92b09e7938d8f276f2749)
endif()

if (NOT SNACK_VERSION)
  set(SNACK_VERSION 2.2.10)
  set(SNACK_HASH 4bfe764547ab92ba58f43b77366dbb7c7b3512d65a27cdbf9e585a9cb64ce81e)
endif()

if (NOT WINDNS_VERSION)
  set(WINDNS_VERSION 0.1.3)
  set(WINDNS_HASH 6d287b01352367becfd107701ea65302092cd68040d1cbd9bfacef47affbb5aa)
endif()

find_program(MAKE_EXE NAMES gmake make REQUIRED)

find_program(TCLSH_EXE
  NAMES tclsh tclsh86 tclsh8.6 tclsh85 tclsh8.5
  HINTS ${CMAKE_INSTALL_PREFIX}
  REQUIRED
)

if (WIN32)
  set(TCLCONFIG_DIR win)
else()
  set(TCLCONFIG_DIR unix)
endif()

ExternalProject_Add(tcl
  URL "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcl/tcl${TCLTK_VERSION}-src.tar.gz"
  URL_HASH SHA256=${TCL_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  PATCH_COMMAND patch -d <SOURCE_DIR> -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/src/patches/tcl.patch && patch -d <SOURCE_DIR> -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/src/patches/tcl-f7fa48.patch
  CONFIGURE_COMMAND <SOURCE_DIR>/${TCLCONFIG_DIR}/configure --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
)

if (APPLE)
set(TK_CONFIG_FLAGS --enable-aqua)
endif()

ExternalProject_Add(tk
  URL "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcl/tk${TCLTK_VERSION}-src.tar.gz"
  URL_HASH SHA256=${TK_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CONFIGURE_COMMAND <SOURCE_DIR>/${TCLCONFIG_DIR}/configure --prefix=${CMAKE_INSTALL_PREFIX} ${TK_CONFIG_FLAGS}
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
  DEPENDS tcl
)

ExternalProject_Add(libressl
  URL "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz"
  URL_HASH SHA256=${LIBRESSL_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DBUILD_SHARED_LIBS=OFF -DLIBRESSL_APPS=OFF -DLIBRESSL_TESTS=OFF
  CMAKE_CACHE_ARGS -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING=${CMAKE_MSVC_RUNTIME_LIBRARY} -DCMAKE_POLICY_DEFAULT_CMP0091:STRING=NEW
  PATCH_COMMAND patch -d <SOURCE_DIR> -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/src/patches/libressl.patch
  UPDATE_COMMAND ""
)

ExternalProject_Add(tls
  URL "https://core.tcl-lang.org/tcltls/uv/tcltls-${TLS_VERSION}.tar.gz"
  URL_HASH SHA256=${TLS_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CONFIGURE_COMMAND CFLAGS=-DLIBRESSL_HAS_TLS1_3=1 PKG_CONFIG_LIBDIR=<INSTALL_DIR>/lib/pkgconfig <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-hardening=false --enable-static-ssl -with-tcl=${CMAKE_INSTALL_PREFIX}/lib --with-ssl=libressl
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
  DEPENDS tcl;libressl
)

ExternalProject_Add(tcllib
  URL "https://core.tcl-lang.org/tcllib/uv/tcllib-${TCLLIB_VERSION}.tar.gz"
  URL_HASH SHA256=${TCLLIB_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-tclsh=${TCLSH_EXE}
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
)

ExternalProject_Add(bwidget
  URL "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcllib/bwidget-${BWIDGET_VERSION}.tar.gz"
  URL_HASH SHA256=${BWIDGET_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND mkdir -p <INSTALL_DIR>/lib/BWidget${BWIDGET_VERSION} && cp -Rp <SOURCE_DIR>/ <INSTALL_DIR>/lib/BWidget${BWIDGET_VERSION}
  UPDATE_COMMAND ""
)

ExternalProject_Add(tcludp
  URL "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tcludp/tcludp-${TCLUDP_VERSION}.tar.gz"
  URL_HASH SHA256=${TCLUDP_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
  DEPENDS tcl
)

ExternalProject_Add(tclvfs
  URL "https://core.tcl-lang.org/tclvfs/tarball/b5e463e712/tclvfs-b5e463e712.tar.gz"
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  PATCH_COMMAND patch -d <SOURCE_DIR> -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/src/patches/tclvfs.patch
  CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
  DEPENDS tcl
)

ExternalProject_Add(memchan
  URL "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/memchan/Memchan${MEMCHAN_VERSION}.tar.gz"
  URL_HASH SHA256=${MEMCHAN_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  PATCH_COMMAND patch -d <SOURCE_DIR> -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/src/patches/memchan.patch
  CONFIGURE_COMMAND autoreconf -if <SOURCE_DIR> && <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND ${MAKE_EXE}
  UPDATE_COMMAND ""
  DEPENDS tcl
)

ExternalProject_Add(snack
  URL "http://www.speech.kth.se/snack/dist/snack${SNACK_VERSION}.tar.gz"
  URL_HASH SHA256=${SNACK_HASH}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  PATCH_COMMAND patch -d <SOURCE_DIR> -p0 < ${CMAKE_CURRENT_SOURCE_DIR}/src/patches/snack.patch
  CONFIGURE_COMMAND <SOURCE_DIR>/${TCLCONFIG_DIR}/configure --prefix=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND ${MAKE_EXE}
  INSTALL_COMMAND ${MAKE_EXE} install DESTDIR=<INSTALL_DIR>
  UPDATE_COMMAND ""
  DEPENDS tcl
)

if (WIN32)
  ExternalProject_Add(windns
    URL "https://github.com/vitalyster/windns/archive/v${WINDNS_VERSION}.tar.gz"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE_EXE}
    INSTALL_COMMAND ${MAKE_EXE} install 
    UPDATE_COMMAND ""
    DEPENDS tcl
  )
  ExternalProject_Add(winico
    URL "https://github.com/vitalyster/winico/archive/master.tar.gz"
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${MAKE_EXE} MPEXPAND="${TCLSH_EXE} <INSTALL_DIR>/lib/tcllib${TCLLIB_VERSION}/modules/doctools/mpexpand"
    INSTALL_COMMAND ${MAKE_EXE} pkgIndex.tcl && ${MAKE_EXE} install-binaries
    UPDATE_COMMAND ""
    DEPENDS tcl;tk;tcllib
  )
else()
  ExternalProject_Add(tkcon
    URL "http://${SOURCEFORGE_MIRROR}.dl.sourceforge.net/sourceforge/tkcon/tkcon-${TKCON_VERSION}.tar.gz"
    URL_HASH SHA256=${TKCON_HASH}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND mkdir -p <INSTALL_DIR>/lib/tkcon${TKCON_VERSION} && cp -Rp <SOURCE_DIR>/tkcon.tcl <SOURCE_DIR>/pkgIndex.tcl <SOURCE_DIR>/README.txt <SOURCE_DIR>/ChangeLog <SOURCE_DIR>/docs <INSTALL_DIR>/lib/tkcon${TKCON_VERSION}
    UPDATE_COMMAND ""
  )
endif()