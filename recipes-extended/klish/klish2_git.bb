FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "Command line interface"
DESCRIPTION = "The klish is a framework for implementing a CISCO-like CLI on a UNIX systems. It is configurable by XML files."

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENCE;md5=763c2d89173e7008fab9b7ecf2605ab5"

SRC_URI = "git://github.com/distro-core-curated-mirrors/klish.git;branch=2.2;protocol=https \
           file://konfd.service \
"

SRCREV = "a3e6035d2b682c79ed3edd9b4fe9642d45d70b4e"
PV = "2.2+git${SRCPV}"

S = "${WORKDIR}/git"

DEPENDS = "libxml2 expat"

RDEPENDS:${PN} = "libxml2 expat"

EXTRA_OECONF:append = ""

EXTRA_OEMAKE:append = " DESTDIR=${D}"

inherit autotools gettext systemd pkgconfig klish2-dir

do_install:append () {
    install -D -m 0644 ${WORKDIR}/konfd.service ${D}${systemd_system_unitdir}/konfd.service
}

SYSTEMD_SERVICE:${PN} = "konfd.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILES:${PN}:append = " ${libdir}/"

# RDEPENDS:${PN}:append = " ${KLISH_PN}"
# FILES:${PN}:append = " ${KLISH_ENABLED_DIR}/"
