FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "Auxiliary functions library"
DESCRIPTION = "The library contains a set of auxiliary functions."

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENCE;md5=763c2d89173e7008fab9b7ecf2605ab5"

SRC_URI = "git://github.com/distro-core-curated-mirrors/faux.git;branch=master;protocol=https"

SRCREV = "3833e7f8809af9187da3979a7e33093b35e2edf0"
PV = "2.2.0+git${SRCPV}"

S = "${WORKDIR}/git"

EXTRA_OECONF:append = ""

EXTRA_OEMAKE:append = " DESTDIR=${D}"

inherit autotools-brokensep gettext pkgconfig

do_install () {
    # NOT IMPLEMENTED oe_runmake install
    install -d ${D}${libdir}
    install -m 0644 ${B}/.libs/libfaux.so.2.0.0 ${D}${libdir}
    ln -sfr ${D}${libdir}/libfaux.so.2.0.0 ${D}${libdir}/libfaux.so.2
    ln -sfr ${D}${libdir}/libfaux.so.2.0.0 ${D}${libdir}/libfaux.so
    install -d ${D}${includedir}/faux
    install -m 0644 ${S}/faux/*.h ${D}${includedir}/faux
}

# NO SYMLINKS for ${libdir}
FILES:${PN}:append = " ${libdir}/libfaux.so.2.0.0"

# ONLY SYMLINKS for ${libdir}
FILES:${PN}-dev:append = " ${includedir} ${libdir}/libfaux.so ${libdir}/libfaux.so.2"

# ONLY STATIC LIBS for ${libdir}
FILES:${PN}-staticdev:append = " ${includedir} ${libdir}/*.a ${libdir}/*.la ${libdir}/*.lai"
