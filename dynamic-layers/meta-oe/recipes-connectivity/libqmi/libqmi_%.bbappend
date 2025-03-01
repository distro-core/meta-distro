PACKAGECONFIG = "udev mbim"

APN ?= ""
APN_USER ?= ""
APN_PASS ?= ""
APN_AUTH ?= ""

do_install:append() {

    cat >${S}/qmi-network.conf <<EOF
APN=${APN}
APN_USER=${APN_USER}
APN_PASS=${APN_PASS}
APN_AUTH=${APN_AUTH}
PROXY=yes
EOF

    install -D -m 0664 ${S}/qmi-network.conf ${D}${sysconfdir}/qmi-network.conf
}

FILES:${PN} += "${bindir}/ ${sysconfdir}/"
