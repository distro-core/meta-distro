FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://modules-load.conf"

COMPATIBLE_MACHINE:x86-64 = "${MACHINE}"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/modules-load.conf ${D}${sysconfdir}/modules-load.d/${PN}.conf
}

FILES:${PN} += "${sysconfdir}/modules-load.d/"
