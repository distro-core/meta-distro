BIN_PREFIX = "${exec_prefix}"

SYSTEMD_AUTO_ENABLE:${PN}-agent = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-server = "disable"

inherit useradd

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "-g 1000 docker ;"
USERADD_PARAM:${PN} = "-p '*' -u 1000 -g 1000 docker ;"
