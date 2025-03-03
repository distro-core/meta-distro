# File: distro-image-license-audit.bbclass
# SPDX-License-Identifier: MIT

# Functions applied to a created rootfs used byu an image; used by
# inherit within an image recipe.

# Apply the same timestamp to all files, append existing

rootfs_update_timestamp:append () {
    # sformatted=$(date -u +%4Y%2m%2d%2H%2M%2S)
    # echo $sformatted > ${IMAGE_ROOTFS}${sysconfdir}/timestamp
    # bbnote "rootfs_update_timestamp set ${sysconfdir}/timestamp to $sformatted"
    if [ -n "${REPRODUCIBLE_TIMESTAMP_ROOTFS}" ]; then
        find ${IMAGE_ROOTFS} -exec touch --no-dereference --date=@${REPRODUCIBLE_TIMESTAMP_ROOTFS} '{}' ';'
    fi
}

# Lock the root account when it has an empty password, replace existing

zap_empty_root_password () {
    if [ -e ${IMAGE_ROOTFS}/etc/shadow ]; then
        sed --follow-symlinks -i 's%^root::%root:*:%' ${IMAGE_ROOTFS}/etc/shadow
    fi
    if [ -e ${IMAGE_ROOTFS}/etc/passwd ]; then
        sed --follow-symlinks -i 's%^root::%root:*:%' ${IMAGE_ROOTFS}/etc/passwd
    fi
}

# Generate a log of all SUID/SGID files

rootfs_sgid_suid_log() {
    find ${IMAGE_ROOTFS} -perm /2000 -exec ls -ln \{\} \; | sed -e "s%${IMAGE_ROOTFS}%%g" >${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-guid.log
    find ${IMAGE_ROOTFS} -perm /4000 -exec ls -ln \{\} \; | sed -e "s%${IMAGE_ROOTFS}%%g" >${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-suid.log
}
ROOTFS_POSTUNINSTALL_COMMAND += "rootfs_sgid_suid_log;"

# ---
