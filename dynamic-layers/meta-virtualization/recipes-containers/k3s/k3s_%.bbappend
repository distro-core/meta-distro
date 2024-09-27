BIN_PREFIX = "${exec_prefix}"

SYSTEMD_AUTO_ENABLE:${PN}-agent = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-server = "disable"

inherit useradd

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "-g 579 docker ;"
USERADD_PARAM:${PN} = "-p '*' -u 579 -g 579 docker ;"
