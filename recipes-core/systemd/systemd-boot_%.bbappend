FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RCONFLICTS:${PN} += "grub-efi"

# meta-intel
inherit ${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'uefi-sign', '', d)}

do_install:append () {
    install -D ${B}/src/boot/efi/systemd-boot${EFI_ARCH}.efi ${D}${EFI_PREFIX}/EFI/BOOT/boot${EFI_ARCH}.efi
	install -D ${B}/src/boot/efi/systemd-boot${EFI_ARCH}.efi ${D}${EFI_PREFIX}/EFI/systemd/systemd-boot${EFI_ARCH}.efi
}

FILES:${PN} += "${EFI_PREFIX}/EFI/"