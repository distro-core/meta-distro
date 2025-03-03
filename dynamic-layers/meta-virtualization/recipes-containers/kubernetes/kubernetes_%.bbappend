SYSTEMD_AUTO_ENABLE:kubelet = "disable"

inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = "-p '*' -U docker ;"
