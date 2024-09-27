inherit useradd

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "-g 599 fwupd-refresh ;"
USERADD_PARAM:${PN} = "-p '*' -u 599 -g 599 fwupd-refresh ;"
