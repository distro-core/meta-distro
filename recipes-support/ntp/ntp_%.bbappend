SRC_URI += "file://ntp.conf"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
	install -m 0644 ${WORKDIR}/ntp.conf ${D}${sysconfdir}/ntp.conf
}
