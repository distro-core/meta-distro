SYSTEMD_AUTO_ENABLE:${PN} = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-secondary = "disable"

do_install:append() {
    rm -fr ${D}/usr/src/debug/aktualizr/
}

FILES:${PN}-src:remove = "/usr/src/debug/aktualizr/"
