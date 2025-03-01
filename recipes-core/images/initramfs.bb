SUMMARY = "Flexible initramfs"
DESCRIPTION = "Flexible initramfs"
LICENSE = "MIT"

# Note: required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

# if "", disables incompatible licenses check
# INCOMPATIBLE_LICENSE = "AGPL-3.0* GPL-3.0* LGPL-3.0*"
# if "", incompatible licenses check has no exceptions, INITRAMFS_IMAGE_BUNDLE precludes GPLv3
# INCOMPATIBLE_LICENSE_EXCEPTIONS = "${@d.getVar('DISTRO_LICENSE_AUDIT') if d.getVar('INITRAMFS_IMAGE_BUNDLE') != "1" else ''}"

IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""

# image (build sizes)
IMAGE_NAME_SUFFIX = ""
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_FSTYPES:remove = "image_repo_manifest ostreepush garagesign garagecheck ota-btrfs ota-ext4 wic ostree ostreecommit ota ostree.tar.gz ota.tar.gz"

# verify required features
CONFLICT_DISTRO_FEATURES = ""
REQUIRED_DISTRO_FEATURES = ""

DEPENDS = "repo-native"

inherit features_check
inherit image
inherit rootfs-postcommands-extend
inherit image-sgid-suid-set
# requires core-image
# inherit ${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'user-key-store', '', d)}

# initramfs-framework as manager
DISTRO_IMAGE_INSTALL = " \
${@bb.utils.contains('MACHINE_FEATURES', 'efi', 'efivar', '', d)} \
${@bb.utils.contains('MACHINE_FEATURES', 'tpm', 'tpm-tools trousers', '', d)} \
${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'tpm2-tools tpm2-abrmd', '', d)} \
os-release-initrd \
initramfs-framework-sota \
cryptsetup \
libdevmapper \
udev \
"
#  parted e2fsprogs-mke2fs dosfstools util-linux-blkid

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
aktualizr-shared-prov-hsm util-linux-more llvm2 less \
"

# Explicitly excluded packages
PACKAGE_EXCLUDE = "util-linux-more kernel-image* kernel-module*"

BAD_RECOMMENDATIONS = "busybox-syslog"

# image_finalize_rootfs() {
# }
# ROOTFS_POSTPROCESS_COMMAND += "image_finalize_rootfs;"

image_set_deploy_links() {
    ln -sf ${IMAGE_NAME}.${IMAGE_FSTYPES} ${IMGDEPLOYDIR}/initrd.img
    ln -sf ${IMAGE_NAME}.${IMAGE_FSTYPES} ${IMGDEPLOYDIR}/${IMAGE_NAME}
}
IMAGE_POSTPROCESS_COMMAND += "image_set_deploy_links;"
