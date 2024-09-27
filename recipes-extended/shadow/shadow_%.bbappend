FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://login \
file://subgid \
file://subuid \
"

RDEPENDS:${PN}:remove = "shadow-securetty"

# PACKAGECONFIG += "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux', '', d)}"
# PACKAGECONFIG += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'logind', '', d)}"

do_install:append() {
    # install -D -m 0644 ${WORKDIR}/login ${D}${sysconfdir}/pam.d/login
    install -D -m 0644 ${WORKDIR}/subgid ${D}${sysconfdir}/subgid
    install -D -m 0644 ${WORKDIR}/subuid ${D}${sysconfdir}/subuid
}

FILES_${PN} += "${sysconfdir}/"
