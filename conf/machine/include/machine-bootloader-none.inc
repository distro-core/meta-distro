# conf/machine/include/machine-grub-efi.inc

# Used to supply boot parameters

# meta-secure-core
UEFI_SELOADER = "0"

# meta-updater
# OSTREE_BOOTLOADER = "none"

# https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html

# selinux permissive/off
APPEND +="${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux=1 enforcing=0', '', d)}"
# console settings
APPEND += "quiet loglevel=3 ${GRUB_SERIAL} console=tty1"
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

# ---
