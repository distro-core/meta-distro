SUMMARY = "packagegroups"
DESCRIPTION = "MACHINE packagegroups"

# POLICY: The packagegroup only reference open source recipes; #there should
# be no company intellectual property associated to these packagegroups, either
# directly or indirectly. RDEPENDS to leaf recipes are allowed, but should be
# migrated to the recipe directly by .bbappends and removed from the packagegroups
# for #proper dependency management.

# Packagegroups are logically partitioned into external and internal use. The
# external packagegroups serve as a meta and are exposed for use by images.
# The internal packagegroups serve as a method to partition functionality or
# features that are then incorporated into the exposed external meta.

# MACHINE packages ARE captured within this packagegroup.

# Examples include images with core functionality and applications captured
# as a named meta packagegroup. The combinations are exposed as

# Packagegroup          Description
# ${PN}-core            Core functionality
# ${PN}-core-sdk        Core functionality with SDK
# ${PN}-full            Full functionality with GUI

# When creating or editing the package groups, generally a new group would
# be internal, and then added to an external meta group. When a specific use
# case is identified for external images, use an existing meta packagegroup
# as the template. Aspects of build-in inclusion are denoted with the use
# of an OVERRIDE from DISTROOVERRIDES or MACHINEOVERRIDES. Where functionality
# is only available from a specific Yocto meta-* layer, incorporate the \
# appropriate conditional checks and test with that layer absent.

# OVERRIDES                 Description
# none                      default required even if empty
# :distro-guest             additions for virtual machine guests
# :distro-gui               additions for gnome, xfce, wayland, x11
# :distro-kubernetes        additions for kubernetes, k3s
# :distro-kvm               additions for kvm, lxc, libvirt
# :distro-testfw            additions for test frameworks
# :libc-glibc               additions for runtime glibc, locales
# :libc-musl                additions for runtime musl
# :<distrooverride>         additions for DISTROOVERRIDES
# :<machineoverride>        additions for MACHINEOVERRIDES

# Pattern used to include dependency supplied by layer-key
# ${@bb.utils.contains('BBFILE_COLLECTIONS', 'layer-key', 'layer-dependencies', '', d)}

# Pattern used to include dependency supplied by distro feature
# ${@bb.utils.contains('DISTRO_FEATURES', 'feature', 'feature-dependencies', '', d)}

# Pattern used to include dependency supplied by machine feature
# ${@bb.utils.contains('MACHINE_FEATURES', 'feature', 'feature-dependencies', '', d)}

# The packages for this package group are expected to be specialized based on MACHINE_ARCH
PACKAGE_ARCH = "${MACHINE_ARCH}"

# meta-intel
INTEL_COMMON_PACKAGE_ARCH ??= "null"
PACKAGE_ARCH:${INTEL_COMMON_PACKAGE_ARCH} = "${INTEL_COMMON_PACKAGE_ARCH}"

# packagegroups to organize within this ${PN}
INTERNAL_PG = "${PN}"

EXCLUDE_FROM_WORLD = "1"

inherit packagegroup

FILES:${PN} = ""
RDEPENDS:${PN} = ""

############################################################

PACKAGES += "${PN}-bootloader-none"
SUMMARY:${PN}-bootloader-none = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-bootloader-none = ""
FILES:${PN}-bootloader-none = ""
RDEPENDS:${PN}-bootloader-none = ""
RRECOMMENDS:${PN}-bootloader-none = ""
RDEPENDS:${PN}-bootloader-none:wsl-amd64 = ""
RDEPENDS:${PN}-bootloader-none:wsl-arm64 = ""

####################

PACKAGES += "${PN}-bootloader-grub-efi"
SUMMARY:${PN}-bootloader-grub-efi = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-bootloader-grub-efi = ""
FILES:${PN}-bootloader-grub-efi = ""
RDEPENDS:${PN}-bootloader-grub-efi = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'efi-secure-boot', bb.utils.contains('MACHINE_FEATURES', 'efi', 'packagegroup-efi-secure-boot', '', d), '', d)} \
${@bb.utils.contains('MACHINE_FEATURES', 'efi', '${INTERNAL_PG}-bootloader-efi-tools grub-efi', '', d)} \
"
# grub-bootconf
RDEPENDS:${PN}-bootloader-grub-efi:wsl-amd64 = ""
RDEPENDS:${PN}-bootloader-grub-efi:wsl-arm64 = ""

####################

PACKAGES += "${PN}-bootloader-l4t-launcher"
SUMMARY:${PN}-bootloader-l4t-launcher = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-bootloader-l4t-launcher = ""
FILES:${PN}-bootloader-l4t-launcher = ""
RDEPENDS:${PN}-bootloader-l4t-launcher = ""
RDEPENDS:${PN}-bootloader-l4t-launcher:wsl-amd64 = ""
RDEPENDS:${PN}-bootloader-l4t-launcher:wsl-arm64 = ""

####################

PACKAGES += "${PN}-bootloader-systemd-boot"
SUMMARY:${PN}-bootloader-systemd = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-bootloader-systemd = ""
FILES:${PN}-bootloader-systemd = ""
RDEPENDS:${PN}-bootloader-systemd = " \
${@bb.utils.contains('MACHINE_FEATURES', 'efi', '${INTERNAL_PG}-bootloader-efi-tools systemd-boot systemd-bootconf', '', d)} \
${@bb.utils.contains('MACHINE_FEATURES', 'efi', 'refind-bin', '', d)} \
"
RDEPENDS:${PN}-bootloader-systemd:esl-amd64 = ""
RDEPENDS:${PN}-bootloader-systemd:esl-arm64 = ""

####################

PACKAGES += "${PN}-bootloader-uboot"
SUMMARY:${PN}-bootloader-uboot = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-bootloader-uboot = ""
FILES:${PN}-bootloader-uboot = ""
RDEPENDS:${PN}-bootloader-uboot = ""
RDEPENDS:${PN}-bootloader-uboot:wsl-amd64 = ""
RDEPENDS:${PN}-bootloader-uboot:wsl-arm64 = ""

####################

PACKAGES += "${PN}-core"
SUMMARY:${PN}-core = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-core = ""
FILES:${PN}-core = ""
RDEPENDS:${PN}-core = " \
${INTERNAL_PG}-bootloader-efi-tools \
${INTERNAL_PG}-bootloader-tpm-tools \
${INTERNAL_PG}-initramfs \
${INTERNAL_PG}-modules \
${INTERNAL_PG}-ostree-boot \
kernel-base \
kernel-dev \
kernel-image \
kernel-image-bzimage \
kernel-modules \
kernel-vmlinux \
"
# kernel-firmware-%s
RDEPENDS:${PN}-core:wsl-amd64 = ""
RDEPENDS:${PN}-core:wsl-arm64 = ""

############################################################

PACKAGES += "${INTERNAL_PG}-bootloader-efi-tools"
SUMMARY:${INTERNAL_PG}-bootloader-efi-tools = "Packagegroup for internal organization"
DESCRIPTION:${INTERNAL_PG}-bootloader-efi-tools = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-bootloader-efi-tools = ""
RDEPENDS:${INTERNAL_PG}-bootloader-efi-tools = " \
${@bb.utils.contains('MACHINE_FEATURES', 'efi', 'efibootmgr efivar', '', d)} \
"
RDEPENDS:${INTERNAL_PG}-bootloader-efi-tools:wsl-amd64 = ""
RDEPENDS:${INTERNAL_PG}-bootloader-efi-tools:wsl-arm64 = ""

####################

PACKAGES += "${INTERNAL_PG}-bootloader-tpm-tools"
SUMMARY:${INTERNAL_PG}-bootloader-tpm-tools = "Packagegroup for internal organization"
DESCRIPTION:${INTERNAL_PG}-bootloader-tpm-tools = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-bootloader-tpm-tools = ""
RDEPENDS:${INTERNAL_PG}-bootloader-tpm-tools = " \
${@bb.utils.contains('MACHINE_FEATURES', 'tpm', 'tpm-tools', '', d)} \
${@bb.utils.contains('MACHINE_FEATURES', 'tpm2', 'tpm2-tools', '', d)} \
"
RDEPENDS:${INTERNAL_PG}-bootloader-tpm-tools:wsl-amd64 = ""
RDEPENDS:${INTERNAL_PG}-bootloader-tpm-tools:wsl-arm64 = ""

####################

# Note: Required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

PACKAGES += "${INTERNAL_PG}-initramfs"
SUMMARY:${INTERNAL_PG}-initramfs = "Packagegroup for internal organization"
DESCRIPTION:${INTERNAL_PG}-initramfs = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-initramfs = ""
RDEPENDS:${INTERNAL_PG}-initramfs = "kernel-initramfs"
RDEPENDS:${INTERNAL_PG}-initramfs:tegra = ""
RDEPENDS:${INTERNAL_PG}-initramfs:wsl-amd64 = ""
RDEPENDS:${INTERNAL_PG}-initramfs:wsl-arm64 = ""

####################

# Note: Limited list of modules to install (prefer to kernel-modules); to specify
# the modules that are included in images over "everything"

PACKAGES += "${INTERNAL_PG}-modules"
SUMMARY:${INTERNAL_PG}-modules = "Packagegroup for internal organization"
DESCRIPTION:${INTERNAL_PG}-modules = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-modules = ""
RDEPENDS:${INTERNAL_PG}-modules = " \
kernel-module-ip-tables \
kernel-module-iptable-filter \
kernel-module-iptable-nat \
kernel-module-nf-nat \
kernel-module-nfnetlink-log \
kernel-module-x-tables \
kernel-module-xt-comment \
kernel-module-xt-connmark \
kernel-module-xt-conntrack \
kernel-module-xt-limit \
kernel-module-xt-mark \
kernel-module-xt-masquerade \
kernel-module-xt-multiport \
kernel-module-xt-nat \
kernel-module-xt-nflog \
kernel-module-xt-statistic \
kernel-module-xt-tcpmss \
"
RDEPENDS:${INTERNAL_PG}-modules:tegra = ""
RDEPENDS:${INTERNAL_PG}-modules:wsl-amd64 = ""
RDEPENDS:${INTERNAL_PG}-modules:wsl-arm64 = ""

####################

PACKAGES += "${INTERNAL_PG}-ostree-boot"
SUMMARY:${INTERNAL_PG}-ostree-boot = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-ostree-boot = ""
FILES:${INTERNAL_PG}-ostree-boot = ""
RDEPENDS:${INTERNAL_PG}-ostree-boot = " \
ostree-booted \
ostree-kernel \
ostree-initramfs \
ostree-devicetrees \
ostree-switchroot \
"
RDEPENDS:${INTERNAL_PG}-ostree-boot:wsl-amd64 = ""
RDEPENDS:${INTERNAL_PG}-ostree-boot:wsl-arm64 = ""
