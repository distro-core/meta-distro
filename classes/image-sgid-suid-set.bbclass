# Distribution SUID is granted through two mechanisms. sudo, or a
# specific command wraopper. It should be considered a bug to
# set an application SUID/SGID bit when that is not the normal method
# of use. This class makes a log of all files in the distribution that
# have SUID/SGID permissions.

# Earlier versions of the software put SUID bits on the following:

# ${bindir}/ostree ${bindir}/systemctl ${sbindir}/chpasswd ${sbindir}/conntrack ${sbindir}/conntrackd
# ${sbindir}/ip.iproute2 ${sbindir}/iptables ${sbindir}/ufw ${sbindir}/wpa_cli ${sbindir}/wpa_supplicant

# Any one of these recipes should be used as the pattern for enabling it via sudo.

rootfs_sgid_suid_log() {
    bbnote "rootfs_sgid_suid_log ${IMAGE_LINK_NAME}-guid.log ${IMAGE_LINK_NAME}-suid.log"
    find ${IMAGE_ROOTFS} -perm /2000 -exec ls -ln \{\} \; | sed -e "s~${IMAGE_ROOTFS}~~g" >${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-guid.log
    find ${IMAGE_ROOTFS} -perm /4000 -exec ls -ln \{\} \; | sed -e "s~${IMAGE_ROOTFS}~~g" >${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-suid.log
}
ROOTFS_POSTUNINSTALL_COMMAND += "rootfs_sgid_suid_log;"
