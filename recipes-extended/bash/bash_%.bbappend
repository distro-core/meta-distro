do_install:append() {
    install -d ${D}${base_bindir}
    ln -sfr ${D}${base_bindir}/bash ${D}${base_bindir}/rbash
}

FILES:${PN} += "${base_bindir}/rbash"

ALTERNATIVE:${PN} = "sh"
ALTERNATIVE_LINK_NAME[sh] = "${base_bindir}/sh"
ALTERNATIVE_TARGET[sh] = "${base_bindir}/bash"
ALTERNATIVE_PRIORITY = "20"
