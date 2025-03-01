FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DESCRIPTION = "Add language support"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
file://locale.conf \
file://vconsole.conf \
file://profile.sh \
"

S = "${WORKDIR}"

do_install(){
    install -D -m 0644 ${S}/locale.conf ${D}${sysconfdir}/locale.conf
    install -D -m 0644 ${S}/vconsole.conf ${D}${sysconfdir}/vconsole.conf
    install -D -m 0644 ${WORKDIR}/profile.sh ${D}${sysconfdir}/profile.d/00-${PN}.sh
}

FILES:${PN} = "${sysconfdir}/"
