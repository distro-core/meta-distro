# inherit by recipe.bb

KLISH_ENABLE_DIR = "${sysconfdir}/klish2"
KLISH_INSTALL_DIR = "${datadir}/klish2"

install_klish_xml() {
    install -d -m 0755 ${D}${KLISH_ENABLE_DIR}
    install -d -m 0755 ${D}${KLISH_INSTALL_DIR}
    install -D -m 644 $1 ${D}${KLISH_INSTALL_DIR}/$(basename $1)
}

enable_klish_xml() {
    ln -sfr ${D}${KLISH_INSTALL_DIR}/$(basename $1) ${D}${KLISH_ENABLE_DIR}/$(basename $1)
}

FILES:${PN}:append = " ${KLISH_ENABLE_DIR}/ ${KLISH_INSTALL_DIR}/"

# ---
