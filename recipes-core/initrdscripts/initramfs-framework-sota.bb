FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Note: required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

SUMMARY = "initramfs-framework modules"
DESCRIPTION = "initramfs-framework modules for lukstpm, luks, and ostree. allows for \
use of cryptsetup encryption at rest, lvm2 layered inside the crypto, and the use of \
any filesystems with minimal configs to other recipes."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

SRC_URI = " \
file://luks \
file://luksefi \
file://lukstpm \
file://ostree \
file://ostreepost \
"

S = "${WORKDIR}"

RDEPENDS:${PN} = " \
initramfs-framework-base \
ostree-switchroot \
"
#initramfs-module-debug
#initramfs-module-udev
#initramfs-module-lvm

# initramfs-module-exec
# initramfs-module-mdev
# initramfs-module-udev
# initramfs-module-e2fs
# initramfs-module-nfsrootfs
# initramfs-module-rootfs
# initramfs-module-debug
# initramfs-module-lvm
# initramfs-module-overlayroot

# Installation order as installed in conjunction with
# initramfs-framework and other modules it supplies:

# 00-debug          # debugging
# 01-mdev           # pick 1 mdev/udev
# 01-udev           # pick 1 mdev/udev
# 07-lukstpm        # obtain luks_keyfile from tpm_nvmem
# 08-luksefi        # obtain luks_keyfile from efi_nvmem
# 09-luks           # open luks partition
# 09-lvm            # activate lvm2 volumes
# 10-e2fs           # mounting ext234
# 85-nfsrootfs      # nfs client
# 89-exec           # exec scripts
# -- all scripts in /exec.d/ --
# 90-rootfs         # mount rootfs
# 91-ostree         # initialize ostree repo to filesystem
# 91-ostreepost     # initialize ostree repo to filesystem
# 91-overlayroot    # overlayfs
# 99-finish         # finish and switch-root

do_install() {
    install -D -m 0755 ${S}/lukstpm ${D}/init.d/07-lukstpm
    install -D -m 0755 ${S}/luksefi ${D}/init.d/08-luksefi
    install -D -m 0755 ${S}/luks ${D}/init.d/09-luks
    install -D -m 0755 ${S}/ostree ${D}/init.d/91-ostree
    install -D -m 0755 ${S}/ostreepost ${D}/init.d/91-ostreepost
}

FILES:${PN} = "/init.d/ /exec.d/"

# PACKAGES += "initramfs-module-luks"
# SUMMARY:initramfs-module-luks = "initramfs luks support"
# RDEPENDS:initramfs-module-luks = "${PN}-base cryptsetup ${INITRAMFS_TPM1} ${INITRAMFS_TPM2} ${INITRAMFS_TPM_KERNEL}"
# FILES:initramfs-module-luks = "/init.d/08-luksefi /init.d/08-lukstpm /init.d/09-luks"

# PACKAGES += "initramfs-module-ostree"
# SUMMARY:initramfs-module-ostree = "initramfs ostree support"
# RDEPENDS:initramfs-module-ostree = "${PN}-base ostree-switchroot"
# FILES:initramfs-module-ostree = "/init.d/91-ostree"

INSANE_SKIP:${PN} = "build-deps"
