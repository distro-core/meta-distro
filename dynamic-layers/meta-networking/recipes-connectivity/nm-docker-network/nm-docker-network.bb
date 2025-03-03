SUMMARY = "NetworkManager Docker Plugin"
DESCRIPTION = "Python plugin for NetworkManager to handle Docker network configurations"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "networkmanager"
RDEPENDS:${PN} = "networkmanager python3-networkmanager python3-dbus python3-pygobject python3-docker"

SRC_URI = " \
file://docker-network.py \
file://docker-network.service \
file://docker-network.nmconnection \
"

S = "${WORKDIR}"

do_install() {
  install -D -m 0644 ${WORKDIR}/docker-network.py ${D}${libdir}/NetworkManager/conf.d/docker-network.py
  install -D -m 0644 ${WORKDIR}/docker-network.service ${D}${libdir}/NetworkManager/conf.d/docker-network.service
  # install -D -m 0600 ${WORKDIR}/docker-network.nmconnection ${D}${sysconfdir}/NetworkManager/system-connections/docker-network.nmconnection
}

FILES:${PN} = "${libdir}/NetworkManager/ ${sysconfdir}/NetworkManager/"
