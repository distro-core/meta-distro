
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "Indicate an OSTree boot"
DESCRIPTION =  "Indicate an OSTree boot"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://ostree-booted.target file://ostree-booted.service"

inherit systemd

SYSTEMD_SERVICE:${PN} = "ostree-booted.target ostree-booted.service"

do_install() {
    install -D -m 0644 ${WORKDIR}/ostree-booted.service ${D}${systemd_system_unitdir}/ostree-booted.service
    install -D -m 0644 ${WORKDIR}/ostree-booted.target ${D}${systemd_system_unitdir}/ostree-booted.target
}

FILES:${PN} = "${systemd_system_unitdir}/"
