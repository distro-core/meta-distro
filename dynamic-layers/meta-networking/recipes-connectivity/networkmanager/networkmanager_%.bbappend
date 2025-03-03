FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://10-networkmanager.pkla \
file://01-default-device.conf \
"

PACKAGECONFIG = "readline nss ifupdown dnsmasq nmcli vala modemmanager wwan \
${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', bb.utils.contains('DISTRO_FEATURES', 'x11', 'consolekit', '', d), d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'bluez5', '', d)} \
${@bb.utils.filter('DISTRO_FEATURES', 'wifi polkit ppp', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux audit', '', d)} \
"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

NETWORKMANAGER_FIREWALL_DEFAULT = "iptables"

# EXTRA_OEMESON += "-Dmodify_system=true"

inherit useradd

USERADD_PACKAGES += "${PN}"
GROUPADD_PARAM:${PN} = "--system netdev"

do_install:append () {
    if [ -n "${@bb.utils.filter('DISTRO_FEATURES', 'polkit', d)}" ]; then
        install -D -m 0660 ${WORKDIR}/10-networkmanager.pkla ${D}${sysconfdir}/polkit-1/localauthority/20-org.d/10-networkmanager.pkla
    fi
    # https://networkmanager.dev/docs/api/latest/NetworkManager.conf.html
    install -D -m 0755 ${WORKDIR}/01-default-device.conf ${D}${sysconfdir}/NetworkManager/conf.d/01-default-device.conf
    # https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html
    install -d -m 0750 ${D}${sysconfdir}/NetworkManager/system-connections
    # install -D -m 0660 ${WORKDIR}/system-connections/example.nmconnection ${D}${sysconfdir}/NetworkManager/system-connections/example.nmconnection
}

FILES:${PN} += "${sysconfdir}/*"
