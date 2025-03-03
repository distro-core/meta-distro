SUMMARY = "ModemManager SWI Plugin"
DESCRIPTION = "Python plugin for ModemManager to handle SWI configurations"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "modemmanager"
RDEPENDS:${PN} = "modemmanager python3-dbus python3-pygobject"

SRC_URI = " \
file://swi-init.py \
file://swi-init.sh \
"

S = "${WORKDIR}"

do_install() {
  install -D -m 0755 ${WORKDIR}/swi-init.py ${D}${libdir}/ModemManager/plugins/swi-init.py
  install -D -m 0755 ${WORKDIR}/swi-init.sh ${D}${libdir}/ModemManager/fcc-unlock-available.d/swi-init.sh
  install -d ${D}${sysconfdir}/ModemManager/fcc-unlock.d
  # ln -s ${libdir}/ModemManager/fcc-unlock.d/swi-unlock.sh ${D}${sysconfdir}/ModemManager/fcc-unlock.d/VENDORID
}

FILES:${PN} = "${libdir}/ModemManager/ ${sysconfdir}/ModemManager/"
