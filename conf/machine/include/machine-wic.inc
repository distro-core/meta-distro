# conf/machine/include/machine-wic.inc

# Used to supply wic parameters

# undesired build artifacts
IMAGE_FSTYPES:remove = "wic"
IMAGE_FSTYPES:remove:sota = "ota-btrfs ota-ext4"

# scripts/lib/wic/canned-wks
WKS_FILE:sota = "${MACHINE}.wks.in"

WKS_FILE_DEPENDS:append = " systemd-bootconf"
WKS_FILE_DEPENDS_BOOTLOADERS = "syslinux grub-efi systemd-boot os-release u-boot"
WKS_FILE_DEPENDS_BOOTLOADERS:tegra = "l4t-launcher grub-efi systemd-boot os-release"

IMAGE_SECUREBOOT_KEYS_DIR = "${TOPDIR}/../../layers/meta-distro/files/user-keys/uefi_sb_keys"

IMAGE_BOOT_FILES = " \
${KERNEL_IMAGETYPE}-${MACHINE}${KERNEL_ARTIFACT_BIN_EXT};${KERNEL_IMAGETYPE} \
${INITRAMFS_IMAGE}-${MACHINE}.${INITRAMFS_FSTYPES};initrd.img \
systemd-boot${EFI_ARCH}.efi;EFI/BOOT/boot${EFI_ARCH}.efi \
"

# partition1
IMAGE_EFI_BOOT_FILES = " \
systemd-boot${EFI_ARCH}.efi;EFI/BOOT/boot${EFI_ARCH}.efi \
systemd-boot${EFI_ARCH}.efi;EFI/systemd/systemd-boot${EFI_ARCH}.efi \
ext2_${EFI_ARCH}.efi;EFI/systemd/drivers/ext2_${EFI_ARCH}.efi \
ext4_${EFI_ARCH}.efi;EFI/systemd/drivers/ext4_${EFI_ARCH}.efi \
btrfs_${EFI_ARCH}.efi;EFI/systemd/drivers/btrfs_${EFI_ARCH}.efi \
"

# partition1
# IMAGE_EFI_BOOT_FILES_label-${GPT_PART_NAME_ESP} = ""

# partition2
# IMAGE_EFI_BOOT_FILES_label-${GPT_PART_NAME_XBOOTLDR} = ""

# ---
