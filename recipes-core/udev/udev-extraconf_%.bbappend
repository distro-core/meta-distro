FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://rules.d \
"

# some distro capture interface rename per device at 70-persistent-net.rules
# systemd performs network renames predictable naming at 80-net-setup-link.rules

do_install:append() {
    install -d -m 0755 ${D}${sysconfdir}/udev/rules.d
    install -d -m 0755 ${D}${nonarch_libdir}/udev/rules.d
    install -m 0644 -t ${D}${nonarch_libdir}/udev/rules.d ${WORKDIR}/rules.d/*
    # alternative is kernel command line net.ifnames=0
    # ln -sf /dev/null ${D}${sysconfdir}/udev/rules.d/70-persistent-net.rules
    # ln -sf /dev/null ${D}${sysconfdir}/udev/rules.d/80-net-setup-link.rules
}

FILES:${PN} += "${sysconfdir}/udev/rules.d/ ${nonarch_libdir}/udev/rules.d/"
