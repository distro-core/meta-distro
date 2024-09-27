BIN_PREFIX = "${exec_prefix}"

SYSTEMD_AUTO_ENABLE:${PN}-agent = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-server = "disable"

inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = "-p '*' -U docker ;"
