# Note: required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

SUMMARY = "Flexible initramfs"
DESCRIPTION = "Flexible initramfs"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# if "", disables incompatible licenses check
# INCOMPATIBLE_LICENSE = "AGPL-3.0* GPL-3.0* LGPL-3.0*"
# if "", incompatible licenses check has no exceptions, INITRAMFS_IMAGE_BUNDLE precludes GPLv3
INCOMPATIBLE_LICENSE_EXCEPTIONS = "${@d.getVar('LOCAL_LICENSE_AUDIT') if d.getVar('INITRAMFS_IMAGE_BUNDLE') != "1" else ''}"

IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""

# image (build sizes)
IMAGE_NAME_SUFFIX = ""
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_FSTYPES:remove = " image_repo_manifest ostreepush garagesign garagecheck ota-btrfs ota-ext4"

# verify required features
CONFLICT_DISTRO_FEATURES = ""
REQUIRED_DISTRO_FEATURES = ""
REQUIRED_DISTRO_FEATURES:distro-full = ""

DEPENDS = "repo-native"

inherit features_check
inherit image
inherit rootfs-postcommands-extend
# inherit image-usr-share-factory
inherit image-sgid-suid-set

# initramfs-framework as manager
DISTRO_IMAGE_INSTALL = " \
os-release-initrd \
initramfs-framework-sota \
tpm-tools \
trousers \
tpm2-tools \
tpm2-abrmd \
efivar \
cryptsetup \
libdevmapper \
udev \
"
# parted e2fsprogs-mke2fs dosfstools util-linux-blkid

# systemd as manager
# DISTRO_IMAGE_INSTALL = " \
# os-release-initrd \
# systemd systemd-initramfs \
# cryptsetup \
# libdevmapper \
# udev \
# "

PACKAGE_INSTALL = "busybox ${DISTRO_IMAGE_INSTALL}"

# Explicitly removed packages
PACKAGE_INSTALL:remove:sota = " \
aktualizr aktualizr-dev-prov aktualizr-dev-prov-hsm \
aktualizr-info aktualizr-lib aktualizr-shared-prov \
aktualizr-shared-prov-hsm util-linux-more \
"

# Explicitly excluded packages
PACKAGE_EXCLUDE = "util-linux-more kernel-image* kernel-module* lvm2"

BAD_RECOMMENDATIONS = "busybox-syslog"

# image_finalize_rootfs() {
# }
# ROOTFS_POSTPROCESS_COMMAND += "image_finalize_rootfs;"

image_set_deploy_links() {
    ln -sf ${IMAGE_NAME}.${IMAGE_FSTYPES} ${IMGDEPLOYDIR}/initrd.img
    ln -sf ${IMAGE_NAME}.${IMAGE_FSTYPES} ${IMGDEPLOYDIR}/${IMAGE_NAME}
}
IMAGE_POSTPROCESS_COMMAND += "image_set_deploy_links;"
