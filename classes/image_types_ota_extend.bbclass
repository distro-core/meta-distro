# File: image_types_ota_extend.bbclass
# SPDX-License-Identifier: MIT

# Original at meta-updater/classes/iimage_types_ota.bbclass

# IMAGE_CMD:ota:prepend() {
#     bbnote "IMAGE_CMD:ota:prepend ${OTA_SYSROOT}"
# }

IMAGE_CMD:ota:append() {
    bbnote "IMAGE_CMD:ota:append ${OTA_SYSROOT}"

    # deploy for DISTRO to support ota
    [ -d ${OTA_SYSROOT}/ostree/deploy/${OSTREE_OSNAME}/deploy/${ostree_target_hash}.0 ] \
        && ln -sfr ${OTA_SYSROOT}/ostree/deploy/${OSTREE_OSNAME}/deploy/${ostree_target_hash}.0 ${OTA_SYSROOT}/ostree/${DISTRO}.0 \
        && ln -sfr ${OTA_SYSROOT}/ostree/deploy/${OSTREE_OSNAME}/deploy/${ostree_target_hash}.0 ${OTA_SYSROOT}/ostree/${DISTRO}.1 \
        || bbfatal "unable to locate ostree_target_hash"

    # capture boot artifacts
    # install -d ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-sota
    # cp -frd -t ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-sota ${OTA_SYSROOT}${EFI_PREFIX}/*
}

# IMAGE_CMD:ota-ext4:prepend() {
#     bbnote "IMAGE_CMD:ota-ext4:prepend ${OTA_SYSROOT} ${EXTRA_IMAGECMD}"
# }

# IMAGE_CMD:ota-ext4:append() {
#     bbnote "IMAGE_CMD:ota-ext4:append ${OTA_SYSROOT} ${EXTRA_IMAGECMD}"
#     # postprocess scripting can use ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.ota-ext4
#     # ln -sfr ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ota-ext4 ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.otaimg
# }

IMAGE_CMD:ota-btrfs:prepend () {
    bbnote "IMAGE_CMD:ota-btrfs:prepend ${OTA_SYSROOT} ${EXTRA_IMAGECMD}"
}

IMAGE_CMD:ota-btrfs:append () {
    bbnote "IMAGE_CMD:ota-btrfs:prepend ${OTA_SYSROOT} ${EXTRA_IMAGECMD}"
    # postprocess scripting can use ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.ota-btrfs
    # ln -sfr ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ota-btrfs ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.otaimg
}
