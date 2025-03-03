FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://10-modemmanager.pkla \
"

PACKAGECONFIG = "vala at mbim qmi \
${@bb.utils.filter('DISTRO_FEATURES', 'systemd polkit', d)} \
"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

inherit useradd

USERADD_PACKAGES += "${PN}"
GROUPADD_PARAM:${PN} = "--system netdev"

do_install:append () {
    if [ -n "${@bb.utils.filter('DISTRO_FEATURES', 'polkit', d)}" ]; then
        install -D -m 0660 ${WORKDIR}/10-modemmanager.pkla ${D}${sysconfdir}/polkit-1/localauthority/20-org.d/10-modemmanager.pkla
    fi
}

FILES:${PN} += "${sysconfdir}/*"
