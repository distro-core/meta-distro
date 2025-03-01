FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://tcsd.conf"

PACKAGECONFIG = ""

EXTRA_OECONF += "--enable-debug"
EXTRA_OECONF += "--with-api=1.2"

DEPENDS:append = " base-passwd"

do_install:append() {
    install -d -m 0770 -o root -g tss ${D}${localstatedir}/lib/tpm
    install -D -m 0640 -o root -g tss ${WORKDIR}/tcsd.conf ${D}${sysconfdir}/tcsd.conf
}

FILES:${PN} += "${localstatedir}/lib/tpm ${sysconfdir}/tcsd.conf"
