SUMMARY = "DISTRO image ${PN}"
DESCRIPTION = "DISTRO image ${PN}"
LICENSE = "MIT"

IMAGE_FEATURES:append = " dev-pkgs"

IMAGE_FSTYPES += ""

IMAGE_LINGUAS = ""

inherit distro-core-image

DISTRO_IMAGE_INSTALL = " \
kernel-initramfs \
ostree-kernel ostree-initramfs ostree-devicetrees \
packagegroup-distro-machine \
packagegroup-distro-machine-bootloader-${EFI_PROVIDER} \
packagegroup-distro-${INIT_MANAGER} \
packagegroup-distro-core \
packagegroup-distro-core-sdk \
"

DISTRO_IMAGE_INSTALL:distro-gui = " \
kernel-initramfs \
ostree-kernel ostree-initramfs ostree-devicetrees \
packagegroup-distro-machine \
packagegroup-distro-machine-bootloader-${EFI_PROVIDER} \
packagegroup-distro-${INIT_MANAGER} \
packagegroup-distro-core \
packagegroup-distro-core-sdk \
packagegroup-distro-full \
"
