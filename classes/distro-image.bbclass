# File: distro-image.bbclass
# SPDX-License-Identifier: MIT

# Base for all images

DEPENDS += "repo-native dnf-native"

# verify required features
CONFLICT_DISTRO_FEATURES = "msft"
REQUIRED_DISTRO_FEATURES = "sota usrmerge"
REQUIRED_DISTRO_FEATURES:distro-gui = "sota usrmerge opengl polkit vulkan wayland x11"

inherit features_check
inherit image
inherit distro-image-rootfs

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

PACKAGE_EXCLUDE += "util-linux-more"

BAD_RECOMMENDATIONS += "busybox-syslog"

# ---
