FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "Command line interface"
DESCRIPTION = "The klish is a framework for implementing a CISCO-like CLI on a UNIX systems. It is configurable by XML files."

# Add .xml descriptions with klish3_%.bbappend in appropriate rescipe folders FILESEXTRAPATHS

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENCE;md5=763c2d89173e7008fab9b7ecf2605ab5"

SRC_URI = "\
git://github.com/distro-core-curated-mirrors/klish.git;branch=master;protocol=https \
file://klishd.conf \
file://klishd.service \
"

SRCREV = "4ac6a82fbbb54c822c8981540beb9c40f17a01fa"
PV = "3.1.0+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "faux libxml2 expat"

RDEPENDS:${PN} = "faux libxml2 expat"

EXTRA_OECONF = ""

EXTRA_OEMAKE = "DESTDIR=${D}"

SYSTEMD_SERVICE:${PN} = "klishd.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

inherit autotools-brokensep gettext systemd pkgconfig klish3-dir

do_install:append () {
    install -D -m 0644 ${WORKDIR}/klishd.conf ${D}${sysconfdir}/klish/klishd.conf
    install -D -m 0644 ${WORKDIR}/klishd.service ${D}${systemd_system_unitdir}/klishd.service
}

# NO SYMLINKS for ${libdir}
FILES:${PN}:append = " ${bindir} ${datadir} ${sysconfdir} ${systemd_system_unitdir} \
    ${libdir}/libklish.so.3.0.0 ${libdir}/libtinyrl.so.3.0.0 \
    ${libdir}/klish/dbs/kdb-ischeme.so ${libdir}/klish/dbs/kdb-ischeme.so \
    ${libdir}/klish/plugins/kplugin-klish.so ${libdir}/klish/plugins/kplugin-script.so \
    "

# ONLY SYMLINKS for ${libdir}
FILES:${PN}-dev:append = " ${includedir} \
    ${libdir}/libklish.so ${libdir}/libklish.so.3 ${libdir}/libtinyrl.so ${libdir}/libtinyrl.so.3 \
    "

# ONLY STATIC LIBS for ${libdir}
FILES:${PN}-staticdev:append = " ${includedir} \
    ${libdir}/*.a ${libdir}/*.la \
    ${libdir}/klish/dbs/*.a ${libdir}/klish/dbs/*.la \
    ${libdir}/klish/plugins/*.a ${libdir}/klish/plugins/*.la \
    "

RDEPENDS:${PN}:append = " ${KLISH_PN}"
FILES:${PN}:append = " ${KLISH_ENABLED_DIR}/"
