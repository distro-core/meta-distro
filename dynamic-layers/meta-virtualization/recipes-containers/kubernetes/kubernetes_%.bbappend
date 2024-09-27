SYSTEMD_AUTO_ENABLE:kubelet = "disable"

inherit useradd

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "-g 1000 docker ;"
USERADD_PARAM:${PN} = "-p '*' -u 1000 -g 1000 docker ;"
