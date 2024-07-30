SUMMARY = "Distro image ${PN}"
DESCRIPTION = "Distro image ${PN}"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# if "", disables incompatible licenses check
# INCOMPATIBLE_LICENSE = "AGPL-3.0* GPL-3.0* LGPL-3.0*"
# if "", incompatible licenses check has no exceptions, INITRAMFS_IMAGE_BUNDLE precludes GPLv3
# INCOMPATIBLE_LICENSE_EXCEPTIONS = "${@d.getVar('LOCAL_LICENSE_AUDIT') if d.getVar('INITRAMFS_IMAGE_BUNDLE') != "1" else ''}"

# # match PACKAGE_ARCH of virtual/kernel
# INTEL_COMMON_PACKAGE_ARCH ??= "null"
# PACKAGE_ARCH = "${MACHINE_ARCH}"
# PACKAGE_ARCH:${INTEL_COMMON_PACKAGE_ARCH} = "${INTEL_COMMON_PACKAGE_ARCH}"

# # set COMPATIBLE_MACHINE to selection
# COMPATIBLE_MACHINE = "(${@d.getVar('MACHINEOVERRIDES').replace(':','|')})"

IMAGE_FEATURES:remove = " dev-pkgs"

IMAGE_LINGUAS = ""

# image (build sizes)
IMAGE_OVERHEAD_FACTOR = "1.2"
IMAGE_ROOTFS_MAXSIZE = "7602176"

IMAGE_FSTYPES:remove = " image_repo_manifest ostreepush garagesign garagecheck ota-btrfs ota-ext4"

# verify required features
CONFLICT_DISTRO_FEATURES = "msft"
REQUIRED_DISTRO_FEATURES = "sota usrmerge"
REQUIRED_DISTRO_FEATURES:distro-full = "sota usrmerge opengl polkit vulkan wayland"

DEPENDS = "repo-native"

inherit features_check
inherit core-image
inherit rootfs-postcommands-extend
inherit image-usr-share-factory
inherit image-sgid-suid-set

DISTRO_IMAGE_INSTALL = " \
${@bb.utils.contains('DISTRO_FEATURES', 'efi', 'refind-bin', '', d)} \
kernel-initramfs \
ostree-kernel ostree-initramfs ostree-devicetrees \
packagegroup-distro-systemd packagegroup-distro-machine \
packagegroup-distro-core \
"

DISTRO_IMAGE_INSTALL:distro-full = " \
${@bb.utils.contains('DISTRO_FEATURES', 'efi', 'refind-bin', '', d)} \
kernel-initramfs \
ostree-kernel ostree-initramfs ostree-devicetrees \
packagegroup-distro-systemd packagegroup-distro-machine \
packagegroup-distro-core \
packagegroup-distro-full \
"

CORE_IMAGE_EXTRA_INSTALL += "${DISTRO_IMAGE_INSTALL}"

# Explicitly removed packages
PACKAGE_INSTALL:remove:sota = " \
aktualizr aktualizr-dev-prov aktualizr-dev-prov-hsm \
aktualizr-info aktualizr-lib aktualizr-shared-prov \
aktualizr-shared-prov-hsm util-linux-more \
"

# Explicitly excluded packages
PACKAGE_EXCLUDE = "util-linux-more"

BAD_RECOMMENDATIONS = "busybox-syslog"

# image_finalize_rootfs() {
# }
# ROOTFS_POSTPROCESS_COMMAND += "image_finalize_rootfs;"

# image_set_deploy_links() {
# }
# IMAGE_POSTPROCESS_COMMAND += "image_set_deploy_links;"
