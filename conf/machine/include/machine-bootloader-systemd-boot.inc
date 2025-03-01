# conf/machine/include/machine-systemd-boot.inc

# Used to supply boot parameters

EFI_PROVIDER = "systemd-boot"

SYSTEMD_BOOT_CFG = "${S}/loader.conf"
# SYSTEMD_BOOT_ENTRIES ?= ""
SYSTEMD_BOOT_SERIAL ?= "console=ttyS1,115200"
SYSTEMD_BOOT_TIMEOUT ?= "60"

SYSTEMD_DEFAULT_TARGET = "multi-user.target"
SYSTEMD_DEFAULT_TARGET:distro-gui = "graphical.target"

# meta-secure-core
UEFI_SELOADER = "0"

# meta-updater
# OSTREE_BOOTLOADER = "none"

# image-live class
# LABELS = ""
# ROOTFS = "${IMAGE_LINK_NAME}"
# INITRD = "${INITRAMFS_IMAGE}-${MACHINE}.${INITRAMFS_FSTYPES}"

BAD_RECOMMENDATIONS:pn-systemd-boot += "grub-efi grub-bootconf"
BAD_RECOMMENDATIONS:pn-systemd-bootconf += "grub-efi grub-bootconf"

# https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html

# selinux permissive/off
APPEND +="${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux=1 enforcing=0', '', d)}"
# console settings
APPEND += "quiet loglevel=3 ${SYSTEMD_BOOT_SERIAL} console=tty1"
# vconsole settings https://www.kernel.org/doc/html/v5.5/admin-guide/svga.html
# vga=773 (1024x768x8), vga=791 (1024x768x16), vga=792 (1024x768x32), vga=3840 (80x25)
APPEND += "vga=792 logo.nologo"
# APPEND += "vconsole.keymap=us vconsole.font=Lat2-Terminus16"
# if "0", use kernel enumerated network names
# APPEND += "net.ifnames=0"
# if set, disables cgroupsv1
# APPEND += "cgroup_no_v1=all"
# if "1", enables cgroupsv2
APPEND += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd.unified_cgroup_hierarchy=1', '', d)}"
# if set, inittialize ramdisk size KiB
# APPEND += "ramdisk_size=16384"
# debug initramfs-framework output
APPEND += "ignore_loglevel debug=true verbose=true"
APPEND += "shell=true shell_debug=true init_fatal_sh=true"
# debug systemd root shell (ALT+F9)
APPEND += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd.debug-shell=on', '', d)}"

# systemd-cryptsetup-generator
APPEND += "rd.luks.name=${FSYS_DEV_UUID_LUKS}=${FSYS_DEV_NAME_LUKS}"
# APPEND += "rd.luks.key=${FSYS_DEV_UUID_LUKS}=/etc/lukskey:LABEL=keydev"
# APPEND += "rd.luks.options=${FSYS_DEV_UUID_LUKS}=discard,..."

# lvm2-activation-generator
# APPEND += "rd.lvm.lv=vg0/root rd.lvm.lv=vg0/var_log rd.lvm.lv=vg0/var_log_audit rd.lvm.lv=vg0/var_lib"

# systemd-fstab-generator
# APPEND += "rd.systemd.mount-extra=UUID=${FSYS_DEV_UUID_ROOT}:/:${FSYS_DEV_TYPE_ROOT}:remount,rw,noatime"
# APPEND += "rd.systemd.mount-extra=UUID=${FSYS_DEV_UUID_ESP_FSTAB}:/efi:${FSYS_DEV_TYPE_ESP}:remount,rw,noatime,nodev,nosuid,noexec"
# APPEND += "rd.systemd.mount-extra=UUID=${FSYS_DEV_UUID_XBOOTLDR}:/boot:${FSYS_DEV_TYPE_XBOOTLDR}:remount,rw,noatime,nodev,nosuid,noexec"
# APPEND += "systemd.mount-extra=UUID=${FSYS_DEV_UUID_LIB}:/var/lib:${FSYS_DEV_TYPE_LIB}:auto,nofail,rw,noatime"
# APPEND += "systemd.mount-extra=UUID=${FSYS_DEV_UUID_LOG}:/var/log:${FSYS_DEV_TYPE_LOG}:auto,nofail,rw,noatime,nodev,nosuid,noexec"
# APPEND += "systemd.mount-extra=UUID=${FSYS_DEV_UUID_AUDIT}:/var/log/audit:${FSYS_DEV_TYPE_AUDIT}:auto,nofail,rw,noatime,nodev,nosuid,noexec"

# rootfs flags (systemd-bootconf)
ROOT = "root=UUID=${FSYS_DEV_UUID_ROOT}"
APPEND += "rootwait rw rootflags=noatime rootfstype=${FSYS_DEV_TYPE_ROOT}"
APPEND:append:sota = " ${ROOT}"

# ---
