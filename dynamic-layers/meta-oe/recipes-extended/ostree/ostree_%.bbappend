FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sudoers"

PACKAGECONFIG:remove = "static"

do_install:append() {
    install -D -m 0640 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}
}

FILES:${PN} += "${sysconfdir}/sudoers.d/"
