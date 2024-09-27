FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sudoers"

DEPENDS:target-native += "composefs-native"

RDEPENDS:${PN} += "composefs"

PACKAGECONFIG:remove = "static"

do_install:append() {
    install -D -m 0640 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}
}

FILES:${PN} += "${sysconfdir}/sudoers.d/"
