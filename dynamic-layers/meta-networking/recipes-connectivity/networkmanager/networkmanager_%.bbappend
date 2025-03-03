FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# SRC_URI += " \
# file://conf.d \
# file://system-connections \
# "

PACKAGECONFIG = "readline nss ifupdown dnsmasq nmcli vala  \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', bb.utils.contains('DISTRO_FEATURES', 'x11', 'consolekit', '', d), d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'bluez5', '', d)} \
    ${@bb.utils.filter('DISTRO_FEATURES', 'wifi polkit ppp', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux audit', '', d)} \
    modemmanager wwan \        
"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

NETWORKMANAGER_FIREWALL_DEFAULT = "iptables"

do_install:append () {
    # https://networkmanager.dev/docs/api/latest/NetworkManager.conf.html
    install -d -m 0755 -d ${D}${sysconfdir}/NetworkManager/conf.d
    # install -m 0644 -t ${D}${sysconfdir}/NetworkManager/conf.d ${WORKDIR}/conf.d/*
    # https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html
    install -m 0700 -d ${D}${sysconfdir}/NetworkManager/system-connections
    # install -m 0600 -t ${D}${sysconfdir}/NetworkManager/system-connections ${WORKDIR}/system-connections/*
}

FILES:${PN} += "${sysconfdir}/NetworkManager/"
