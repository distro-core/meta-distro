FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "Multi-link VPN"
DESCRIPTION = "ADSL/SDSL/xDSL/Network aggregation / bonding"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENCE;md5=db3df3fd968e00ce5a222a1867e9a16f"

SRC_URI = " \
git://github.com/zehome/MLVPN.git;branch=master;protocol=https \
file://mlvpn@.service \
"

SRCREV = "bc4fc54f19b24786d1a92e2beac45cbe2d6086e6"
PV = "2.3.5+git${SRCPV}"

S = "${WORKDIR}/git"

TOOLCHAIN = "gcc"

DEPENDS = "libpcap libsodium libev"

RDEPENDS:${PN} = "libpcap libsodium libev"

inherit autotools gettext systemd pkgconfig

SYSTEMD_SERVICE:${PN} = "mlvpn@.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

EXTRA_OECONF = ""

EXTRA_OEMAKE += "DESTDIR=${D} CFLAGS='${CFLAGS} -Wl,--allow-multiple-definition'"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/mlvpn@.service ${D}${systemd_system_unitdir}/mlvpn@.service
}

FILES:${PN} += "${libdir}/ ${systemd_system_unitdir}/"
