FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "openrc-stub"
DESCRIPTION = "openrc-stub satisfy build dependency"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

do_install() {
    touch ${S}/openrc-run
    install -D -m 0755 ${S}/openrc-run ${D}/sbin/openrc-run
}

FILES:${PN} = "/sbin/"
