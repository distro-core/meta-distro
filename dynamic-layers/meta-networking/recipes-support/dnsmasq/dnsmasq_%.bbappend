FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://dnsmasq.conf"

SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_install:append() {
	install -m 0644 ${WORKDIR}/dnsmasq.conf ${D}${sysconfdir}/dnsmasq.conf
}
