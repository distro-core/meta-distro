# Original at poky/meta/classes-recipe/rootfs-postcommands.bbclass

rootfs_update_timestamp:append () {
    # sformatted=$(date -u +%4Y%2m%2d%2H%2M%2S)
    # echo $sformatted > ${IMAGE_ROOTFS}${sysconfdir}/timestamp
    # bbnote "rootfs_update_timestamp set ${sysconfdir}/timestamp to $sformatted"
    if [ -n "${REPRODUCIBLE_TIMESTAMP_ROOTFS}" ]; then
        find ${IMAGE_ROOTFS} -exec touch --no-dereference --date=@${REPRODUCIBLE_TIMESTAMP_ROOTFS} '{}' ';'
    fi
}

zap_empty_root_password () {
    if [ -e ${IMAGE_ROOTFS}/etc/shadow ]; then
        sed --follow-symlinks -i 's%^root::%root:*:%' ${IMAGE_ROOTFS}/etc/shadow
    fi
    if [ -e ${IMAGE_ROOTFS}/etc/passwd ]; then
        sed --follow-symlinks -i 's%^root::%root:*:%' ${IMAGE_ROOTFS}/etc/passwd
    fi
}
