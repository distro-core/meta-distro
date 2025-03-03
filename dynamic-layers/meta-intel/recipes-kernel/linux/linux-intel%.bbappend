FILESEXTRAPATHS:prepend := "${THISDIR}/linux:"

require recipes-kernel/linux/distro-linux-common.inc

require ${@bb.utils.contains('DISTRO_FEATURES', 'ima', 'recipes-kernel/linux/linux-yocto-ima.inc', '', d)}
require ${@bb.utils.contains('DISTRO_FEATURES', 'modsign', 'recipes-kernel/linux/linux-yocto-modsign.inc', '', d)}

SRC_URI += "file://cmdline.cfg"
