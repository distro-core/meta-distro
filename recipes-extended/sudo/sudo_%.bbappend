FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    #echo "@includedir /etc/sudoers.d" >> ${D}${sysconfdir}
    install -d -m 0750 ${D}${sysconfdir}/sudoers.d
}

FILES:${PN} += "${sysconfdir}/sudoers.d/"
