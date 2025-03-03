FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SYSTEMD_AUTO_ENABLE:${PN} = "disable"

# do_install:append() {
#     install -d ${D}${sysconfdir}/systemd/system
#     ln -sf ${D}${sysconfdir}/systemd/system/rpcbind.service
#     ln -sf ${D}${sysconfdir}/systemd/system/rpcbind.socket
# }

# FILES:${PN}:append = " ${sysconfdir}/systemd/system/rpcbind.service"
