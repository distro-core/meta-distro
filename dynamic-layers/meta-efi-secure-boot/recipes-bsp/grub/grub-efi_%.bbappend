FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RPROVIDES:${PN} += "virtual-grub-bootconf"

RCONFLICTS:${PN} += "grub-bootconf"

GRUB_BUILDIN += "all"

GRUB_EFI_PASSWORD ??= "password"

# do_install:append:class-target() {
#   # if ${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'true', 'false', d)} ; then
#     sed -i -e "s|@APPEND@|${APPEND}|g" ${D}${EFI_BOOT_PATH}/boot-menu.inc
#     sed -i -e "s|@OSTREE_KERNEL_ARGS@|${OSTREE_KERNEL_ARGS}|g" ${D}${EFI_BOOT_PATH}/boot-menu.inc
#     password=$(printf "${GRUB_EFI_PASSWORD}\n${GRUB_EFI_PASSWORD}\n" | grub-mkpasswd-pbkdf2 --iteration-count=10000 | tail -1 | cut -d' ' -f7)
#     sed -i -e "s|@GRUB_EFI_PASSWORD@|$password|g" ${D}${EFI_BOOT_PATH}/password.inc
#   # fi
# }
