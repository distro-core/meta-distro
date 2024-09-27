DEPENDS += "json-glib"

RDEPENDS:${PN} += "json-glib"

SYSTEMD_AUTO_ENABLE:${PN} = "disable"
