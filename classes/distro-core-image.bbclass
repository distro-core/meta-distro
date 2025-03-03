# File: distro-core-image.bbclass
# SPDX-License-Identifier: MIT

# Adds core featuers

DEPENDS += "repo-native dnf-native"

# verify required features
CONFLICT_DISTRO_FEATURES = "msft"
REQUIRED_DISTRO_FEATURES = "sota usrmerge"
REQUIRED_DISTRO_FEATURES:distro-gui = "sota usrmerge opengl polkit vulkan wayland x11"

inherit features_check
inherit core-image
inherit distro-image-rootfs

IMAGE_CLASSES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'image_types_ostree_extend image_types_ota_extend', '', d)}"
IMAGE_CLASSES += "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'user-key-store', '', d)}"
IMAGE_CLASSES += "${@bb.utils.contains('DISTRO_FEATURES', 'usrmerge', 'distro-image-usrmerge','',d)}"
IMAGE_CLASSES += "${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'uefi-sign', '', d)}"

DISTRO_IMAGE_INSTALL ??= ""

CORE_IMAGE_EXTRA_INSTALL += "${DISTRO_IMAGE_INSTALL}"

# Explicitly removed packages

PACKAGES_AKTUALIZR = " \
aktualizr aktualizr-dev-prov aktualizr-dev-prov-hsm \
aktualizr-info aktualizr-lib aktualizr-shared-prov \
aktualizr-shared-prov-hsm util-linux-more less \
"

PACKAGE_INSTALL:remove:sota = "${PACKAGES_AKTUALIZR}"

PACKAGE_INSTALL:remove:wsl-amd64 = "${PACKAGES_AKTUALIZR} \
ostree-booted ostree-kernel ostree-initramfs ostree-devicetrees ostree-switchroot \
"

PACKAGE_INSTALL:remove:wsl-arm64 = "${PACKAGES_AKTUALIZR} \
ostree-booted ostree-kernel ostree-initramfs ostree-devicetrees ostree-switchroot \
"

IMAGE_CLASSES:remove:wsl-amd64 = "image_repo_manifest"

IMAGE_CLASSES:remove:wsl-arm64 = "image_repo_manifest"

IMAGE_FSTYPES:remove:wsl-amd64 = "ostreepush garagesign garagecheck ostree ostree.tar.gz ota ota.tar.gz ota-btrfs ota-ext4"

IMAGE_FSTYPES:remove:wsl-arm64 = "ostreepush garagesign garagecheck ostree ostree.tar.gz ota ota.tar.gz ota-btrfs ota-ext4"

PACKAGE_EXCLUDE += "util-linux-more"

BAD_RECOMMENDATIONS += "busybox-syslog"

# ---
