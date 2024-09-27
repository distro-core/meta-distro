FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://sysctl.conf"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/sysctl.conf ${D}${sysconfdir}/sysctl.d/80-${PN}.conf
}
