FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://systemd-override.conf"

SYSTEMD_AUTO_ENABLE:${PN} = "${@bb.utils.contains('DISTRO_FEATURES', 'tpm2', 'enable', 'disable', d)}"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/systemd-override.conf ${D}${systemd_system_unitdir}/tpm2-abrmd.service.d/systemd-override.conf
}

FILES:${PN} += "${systemd_system_unitdir}/"
