# included by conf/distro/distro-common.conf
# original at meta-updater/conf/sota.conf.inc

# Used to setup sota from meta-updater

DISTRO_FEATURES:append = " sota usrmerge"
DISTRO_FEATURES_NATIVE:append = " sota usrmerge"

INHERIT += "sota"

# for persistence, set in environment to override, export OSTREE_REPO='<path>'
OSTREE_REPO = "${DEPLOY_DIR}/ostree_repo"
# refs branch
OSTREE_BRANCHNAME = "${DISTRO}-${MACHINE}_${BPN}_${DISTRO_VERSION}"

# disable default tarball creation
BUILD_OSTREE_TARBALL = "0"
BUILD_OTA_TARBALL = "0"

# enable specific tarball creation .tar.gz
IMAGE_FSTYPES:append:sota = " ostree.tar.gz ota.tar.gz"

# undesired build artifacts by OVERRIDES
IMAGE_FSTYPES:remove:sota = "image_repo_manifest ostreepush garagesign garagecheck ota-btrfs ota-ext4 wic"

OSTREE_OSNAME ?= "${DISTRO}"
OSTREE_BOOTLOADER ?= "none"
OSTREE_BOOT_PARTITION = "${EFI_PREFIX}"
OSTREE_KERNEL = "${KERNEL_IMAGETYPE}"
OSTREE_DEPLOY_DEVICETREE ?= "1"
OSTREE_DEVICETREE = "${KERNEL_DEVICETREE}"
OSTREE_MULTI_DEVICETREE_SUPPORT ?= "0"
OSTREE_SYSROOT_READONLY = "1"
OSTREE_KERNEL_ARGS = "${APPEND}"

# gpg signing (keys.conf)
# OSTREE_GPGDIR = "${MASTER_KEYS_DIR}/rpm_keys"
# OSTREE_GPGID = "RPM Signing"
# OSTREE_GPG_PASSPHRASE = "passphrase"
# OSTREE_GRUB_PW_FILE = "${GRUB_PW_FILE}"
# EXTRA_OSTREE_COMMIT:append = "--gpg-sign=${OSTREE_GPGID} --gpg-homedir=${OSTREE_GPGDIR}"

OSTREE_COMMIT_SUBJECT ?= "Commit-id: ${OSTREE_BRANCHNAME}"
# OSTREE_COMMIT_BODY ?= ""
OSTREE_COMMIT_VERSION ?= "${DISTRO_VERSION}"
# OSTREE_UPDATE_SUMMARY ?= "1"

# https://ostreedev.github.io/ostree/man/ostree.repo-config.html
OSTREE_REPO_CONFIG = " \
core.add-remotes-config-dir:true \
core.min-free-space-size:1024MB \
sysroot.bootloader=auto \
"

# https://ostreedev.github.io/ostree/man/ostree.repo-config.html
OSTREE_OTA_REPO_CONFIG = " \
core.add-remotes-config-dir:true \
core.min-free-space-size:1024MB \
sysroot.bootloader=auto \
"

# from files/user-keys/keys.conf
OSTREE_GPG_SIGN_ARGS = "${@'--gpg-sign=${OSTREE_GPGID}' if d.getVar('OSTREE_GPGID') else ''}"
OSTREE_GPG_HOMEDIR_ARGS = "${@'--gpg-homedir=${OSTREE_GPGDIR}' if d.getVar('OSTREE_GPGDIR') else ''}"
# EXTRA_OSTREE_COMMIT:append = " ${OSTREE_GPG_SIGN_ARGS} ${OSTREE_GPG_HOMEDIR_ARGS}"

SOTA_MACHINE = "none"
SOTA_MACHINE:sota = "none"
SOTA_MACHINE:intel-corei7-64 = "none"

# EXTRA_IMAGECMD:ota-ext4 = "-L otaroot -i 4096 -t ext4"
# -O quota -E quotatype=usrquota:grpquota:prjquota
EXTRA_IMAGECMD:ota-ext4 = "-b 4096 -i 4096 -t ext4 -L '${FSYS_DEV_NAME_ROOT}' -U ${FSYS_DEV_UUID_ROOT}"

# EXTRA_IMAGECMD:ota-btrfs = "-L otaroot -n 4096 --shrink"
# -O quota
EXTRA_IMAGECMD:ota-btrfs = "-s 4096 -n 4096 --shrink -L '${FSYS_DEV_NAME_ROOT}' -U ${FSYS_DEV_UUID_ROOT}"

# ---
