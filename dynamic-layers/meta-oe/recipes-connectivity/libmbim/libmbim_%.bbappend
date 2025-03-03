APN ?= ""
APN_USER ?= ""
APN_PASS ?= ""
APN_AUTH ?= ""

do_install:append() {

    cat >${S}/mbim-network.conf <<EOF
APN=${APN}
APN_USER=${APN_USER}
APN_PASS=${APN_PASS}
APN_AUTH=${APN_AUTH}
PROXY=yes
EOF

    install -D -m 0664 ${S}/mbim-network.conf ${D}${sysconfdir}/mbim-network.conf
}

FILES:${PN} += "${bindir}/ ${sysconfdir}/"
