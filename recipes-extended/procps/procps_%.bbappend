FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
file://sysctl.d \
"

do_install:append() {
    install -d -m 0755 ${D}${sysconfdir}/sysctl.d/
    install -m 0644 -t ${D}${sysconfdir}/sysctl.d ${WORKDIR}/sysctl.d/*
}

FILES:${PN}:append = " ${sysconfdir}/sysctl.d/"
