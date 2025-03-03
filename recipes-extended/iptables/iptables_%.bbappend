FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://ip6tables.rules file://iptables.rules file://sudoers"

PACKAGECONFIG += "${@bb.utils.filter('DISTRO_FEATURES', 'ipv6', d)} libnfnetlink libnftnl"

RDEPENDS:${PN} += " \
${PN}-apply \
${PN}-modules \
netbase \
"

RRECOMMENDS:${PN}:class-target += " \
${@bb.utils.contains('PACKAGECONFIG', 'ipv6', 'kernel-module-ip6table-filter kernel-module-ip6-tables', '', d)} \
kernel-module-ip-tables kernel-module-iptable-filter kernel-module-iptable-nat kernel-module-nf-nat kernel-module-x-tables \
kernel-module-nf-conntrack kernel-module-ipt-masquerade kernel-module-nf-conntrack-ipv4 kernel-module-nf-defrag-ipv4 \
"

do_install:append() {

    install -D -m 0640 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}

    # remove conflict with netbase_%.bb
    mv -f ${D}${sysconfdir}/ethertypes ${D}${sysconfdir}/ethertypes.${PN}
}

FILES:${PN} += "${sysconfdir}/sudoers.d/ ${IPTABLES_RULES_DIR}/"
