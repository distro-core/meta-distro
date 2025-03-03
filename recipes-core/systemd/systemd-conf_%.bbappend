FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://journald.conf \
file://timesyncd.conf \
file://logind.conf \
file://networkd.conf \
file://resolved.conf \
file://sleep.conf \
file://system.conf \
file://user.conf \
"

do_install:append() {

    install -d -m 0755 ${D}${sysconfdir}/systemd/system

    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/sleep.target
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/sleep.target
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/suspend.target
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/hibernate.target
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/hybrid-sleep.target

    install -D -m 0644 ${WORKDIR}/journald.conf ${D}${sysconfdir}/systemd/journald.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/logind.conf ${D}${sysconfdir}/systemd/logind.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/networkd.conf ${D}${sysconfdir}/systemd/networkd.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/resolved.conf ${D}${sysconfdir}/systemd/resolved.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/systemd/system.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/sleep.conf ${D}${sysconfdir}/systemd/sleep.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/timesyncd.conf ${D}${sysconfdir}/systemd/timesyncd.conf.d/00-${PN}.conf
    install -D -m 0644 ${WORKDIR}/user.conf ${D}${sysconfdir}/systemd/user.conf.d/00-${PN}.conf

    # install -D -m 0644 ${WORKDIR}/vconsole.conf ${D}${sysconfdir}/vconsole.conf
    # install -d ${D}${sysconfdir}/systemd/system/sysinit.target.wants
    # ln -sf ${systemd_system_unitdir}/systemd-vconsole-setup.service ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-vconsole-setup.service
    # install -D -m 0644 ${WORKDIR}/systemd-vconsole-setup.conf ${D}${sysconfdir}/systemd/system/systemd-vconsole-setup.service.d/00-${PN}.conf
}

FILES:${PN} += "${sysconfdir}/systemd/"
