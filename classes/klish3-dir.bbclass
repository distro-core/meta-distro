# inherit by recipe.bb

KLISH3_ENABLE_DIR = "${sysconfdir}/klish3"
KLISH3_INSTALL_DIR = "${datadir}/klish3"

install_klish3_xml() {
    install -d -m 0755 ${D}${KLISH3_ENABLE_DIR}
    install -d -m 0755 ${D}${KLISH3_INSTALL_DIR}
    install -D -m 644 $1 ${D}${KLISH3_INSTALL_DIR}/$(basename $1)
}

enable_klish3_xml() {
    ln -sfr ${D}${KLISH3_INSTALL_DIR}/$(basename $1) ${D}${KLISH3_ENABLE_DIR}/$(basename $1)
}

FILES:${PN}:append = " ${KLISH3_ENABLE_DIR}/ ${KLISH3_INSTALL_DIR}/"

# ---
