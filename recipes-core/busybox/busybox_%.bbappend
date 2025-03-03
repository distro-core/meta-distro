FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://config.cfg \
            file://busybox.conf \
           "

BUSYBOX_SPLIT_SUID = "0"

# Prioritize busybox utility
ALTERNATIVE_PRIORITY[awk] = "250"
ALTERNATIVE_PRIORITY[bash] = "250"
ALTERNATIVE_PRIORITY[ed] = "250"
ALTERNATIVE_PRIORITY[grep] = "250"
ALTERNATIVE_PRIORITY[less] = "250"
ALTERNATIVE_PRIORITY[more] = "250"
ALTERNATIVE_PRIORITY[mount] = "250"
ALTERNATIVE_PRIORITY[ping] = "250"
ALTERNATIVE_PRIORITY[ping6] = "250"
ALTERNATIVE_PRIORITY[sed] = "250"
ALTERNATIVE_PRIORITY[sh] = "250"
ALTERNATIVE_PRIORITY[traceroute] = "250"
ALTERNATIVE_PRIORITY[ucdhcpc] = "250"
ALTERNATIVE_PRIORITY[umount] = "250"
ALTERNATIVE_PRIORITY[vi] = "250"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/busybox.conf ${D}${sysconfdir}/busybox.conf
}

FILES:${PN}:append = " ${sysconfdir}/"

SYSTEMD_SERVICE:${PN}-syslog = ""

RDEPENDS:${PN}-ptest:remove = ""

# pkg_postinst_ontarget:${PN} () {
#     echo "pkg_postinst_ontarget:${PN}"
# }
