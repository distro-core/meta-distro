SYSTEMD_AUTO_ENABLE:kubelet = "disable"

inherit useradd

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "-g 579 docker ;"
USERADD_PARAM:${PN} = "-p '*' -u 579 -g 579 docker ;"
