FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rules.d file://auditd.conf"

do_install:append() {
    install -d -m 0755 ${D}${sysconfdir}/audit/rules.d
    install -m 0644 ${WORKDIR}/auditd.conf ${D}${sysconfdir}/audit/auditd.conf
    install -m 0644 -t ${D}${sysconfdir}/audit/rules.d ${WORKDIR}/rules.d/*
}

FILES:${PN} += "${sysconfdir}/audit/"
