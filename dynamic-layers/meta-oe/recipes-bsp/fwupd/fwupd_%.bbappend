inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = "-p '*' -U fwupd-refresh ;"
