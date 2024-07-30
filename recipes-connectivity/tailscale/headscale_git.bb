FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "wireguard vpn server"
DESCRIPTION = "The easiest, most secure way to use WireGuard and 2FA."

GO_IMPORT = "github.com/juanfont/headscale"

SRC_URI = "git://${GO_IMPORT};branch=main;protocol=https;destdir=${BPN}-${PV}/src/${GO_IMPORT}"

SRCREV = "${AUTOREV}"
PV = "0.0+git${SRVPV}"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=a672713a9eb730050e491c92edf7984d"

inherit go-mod systemd

do_install:append() {
    install -D -m 0644 ${S}/src/${GO_IMPORT}/docs/packaging/headscale.systemd.service ${D}${systemd_system_unitdir}/headscale.service
}

SYSTEMD_SERVICE:${PN} = "headscale.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILES:${PN} += "${GOBIN_FINAL}/ ${systemd_system_unitdir}/"

INSANE_SKIP:${PN}-dev += "file-rdeps"
