FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# SRC_URI += "file://conf.d"

DEPENDS += "paho-mqtt-c"

RDEPENDS:${PN} += "paho-mqtt-c"

do_install:append() {
    install -d -m 0755 ${D}${sysconfdir}/syslog-ng/conf.d
    # install -m 0644 -t ${D}${sysconfdir}/syslog-ng/conf.d ${WORKDIR}/conf.d/*
}

FILES:${PN} += "${sysconfdir}/syslog-ng/conf.d/"
