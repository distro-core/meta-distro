SUMMARY = "DISTRO image ${PN}"
DESCRIPTION = "DISTRO image ${PN}"
LICENSE = "MIT"
HOMEPAGE = "https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro"

# if "", disables incompatible licenses check
# INCOMPATIBLE_LICENSE = "AGPL-3.0* GPL-3.0* LGPL-3.0*"
# if "", incompatible licenses check has no exceptions, INITRAMFS_IMAGE_BUNDLE precludes GPLv3
# INCOMPATIBLE_LICENSE_EXCEPTIONS = "${@d.getVar('DISTRO_LICENSE_AUDIT') if d.getVar('INITRAMFS_IMAGE_BUNDLE') != "1" else ''}"

IMAGE_FEATURES:append = " dev-pkgs"

IMAGE_FSTYPES += "wsl"

IMAGE_LINGUAS = ""

# verify required features
CONFLICT_DISTRO_FEATURES = "msft"
REQUIRED_DISTRO_FEATURES = "sota usrmerge"
REQUIRED_DISTRO_FEATURES:distro-gui = "sota usrmerge opengl polkit vulkan wayland x11"

DEPENDS += "repo-native dnf-native"

inherit core-image
inherit rootfs-postcommands-extend
inherit image-sgid-suid-set
inherit ${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'uefi-sign', '', d)}
inherit ${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'user-key-store', '', d)}

DISTRO_IMAGE_INSTALL = " \
distro-wsl-conf \
packagegroup-distro-${INIT_MANAGER} \
packagegroup-distro-core \
packagegroup-distro-core-sdk \
"

DISTRO_IMAGE_INSTALL:distro-gui = " \
distro-wsl-conf \
packagegroup-distro-${INIT_MANAGER} \
packagegroup-distro-core \
packagegroup-distro-core-sdk \
packagegroup-distro-full \
"

CORE_IMAGE_EXTRA_INSTALL += "${DISTRO_IMAGE_INSTALL}"

# Explicitly removed packages
PACKAGE_INSTALL:remove:sota = " \
aktualizr aktualizr-dev-prov aktualizr-dev-prov-hsm \
aktualizr-info aktualizr-lib aktualizr-shared-prov \
aktualizr-shared-prov-hsm util-linux-more less \
"

# Explicitly excluded packages
PACKAGE_EXCLUDE = "util-linux-more kernel-image* kernel-module*"

BAD_RECOMMENDATIONS = "busybox-syslog"

# image_finalize_rootfs() {
# }
# ROOTFS_POSTPROCESS_COMMAND += "image_finalize_rootfs;"

# image_set_deploy_links() {
# }
# IMAGE_POSTPROCESS_COMMAND += "image_set_deploy_links;"
