FILESEXTRAPATHS:prepend := "${THISDIR}/linux:"

SRC_URI += "file://cmdline.cfg"

require recipes-kernel/linux/distro-linux-common.inc

require ${@bb.utils.contains('DISTRO_FEATURES', 'ima', 'recipes-kernel/linux/linux-yocto-ima.inc', '', d)}
require ${@bb.utils.contains('DISTRO_FEATURES', 'modsign', 'recipes-kernel/linux/linux-yocto-modsign.inc', '', d)}

# do_patch:append() {
#   bbwarn "WORKDIR ${WORKDIR} S ${S} B ${B}"
#   if [ -f ${WORKDIR}/cmdline.cfg ]; then
#     echo 'CONFIG_CMDLINE_BOOL=y' >> ${WORKDIR}/cmdline.cfg
#     echo 'CONFIG_CMDLINE="${APPEND}"' >> ${WORKDIR}/cmdline.cfg
#   else
#     bberror "DOES NOT EXIST ${WORKDIR}/cmdline.cfg"
#   fi
# }
