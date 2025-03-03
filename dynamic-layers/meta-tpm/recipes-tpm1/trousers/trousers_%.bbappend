FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://tcsd.conf file://systemd-override.conf"

PACKAGECONFIG = ""

EXTRA_OECONF += "--enable-debug --with-api=1.2"

SYSTEMD_AUTO_ENABLE:${PN} = "${@bb.utils.contains('DISTRO_FEATURES', 'tpm', 'enable', 'disable', d)}"

do_install:append() {
    install -d -m 0770 -g tss ${D}${localstatedir}/lib/tpm
    install -D -m 0644 -g tss ${WORKDIR}/tcsd.conf ${D}${sysconfdir}/tcsd.conf
    install -D -m 0644 ${WORKDIR}/systemd-override.conf ${D}${systemd_system_unitdir}/tcsd.service.d/systemd-override.conf
}

FILES:${PN} += "${localstatedir}/ ${sysconfdir}/ ${systemd_system_unitdir}/"
