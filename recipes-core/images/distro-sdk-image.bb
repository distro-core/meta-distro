SUMMARY = "DISTRO image ${PN}"
DESCRIPTION = "DISTRO image ${PN}"
LICENSE = "MIT"

IMAGE_FEATURES:append = " dev-pkgs"

IMAGE_FSTYPES += ""

IMAGE_LINGUAS = ""

DISTRO_IMAGE_INSTALL = " \
packagegroup-distro-machine-bootloader-${EFI_PROVIDER} \
packagegroup-distro-machine-bootloader-efi-tools \
packagegroup-distro-machine-bootloader-tpm-tools \
packagegroup-distro-machine-core \
packagegroup-distro-machine-initramfs \
packagegroup-distro-machine-modules \
packagegroup-distro-machine-ostree-boot \
packagegroup-distro-${INIT_MANAGER} \
packagegroup-distro-core \
packagegroup-distro-core-sdk \
packagegroup-distro-full \
"

# Selection of individual packagegroups
DISTRO_IMAGE_INSTALL:remove = "packagegroup-distro-machine"

inherit distro-core-image
