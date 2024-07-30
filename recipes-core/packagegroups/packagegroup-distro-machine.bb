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

# OVERRIDES             Description
# none                  default packagegroup, required even if empty
# :distro-guest         additions for virtual machine guests
# :distro-gui           additions for gnome, xfce, wayland, x11
# :distro-kubernetes    additions for kubernetes, k3s
# :distro-kvm           additions for kvm, lxc, libvirt
# :distro-testfw        additions for test frameworks
# :libc-glibc           additions for runtime glibc, locales
# :libc-musl            additions for runtime musl
# :<distro_name>        additions for specific DISTRO
# :<machine_arch>       additions for specific MACHINE

PACKAGE_ARCH = "${MACHINE_ARCH}"

# meta-intel
INTEL_COMMON_PACKAGE_ARCH ??= "null"
PACKAGE_ARCH:${INTEL_COMMON_PACKAGE_ARCH} = "${INTEL_COMMON_PACKAGE_ARCH}"

# packagegroups to organize within ${PN}
INTERNAL_PG = "${PN}-local"

EXCLUDE_FROM_WORLD = "1"

inherit packagegroup

################################################################################
# LICENSE open source packages
################################################################################

# internal-pattern
# PACKAGES += "${INTERNAL_PG}-pattern"
# SUMMARY:${INTERNAL_PG}-pattern = "internal packagegroup use"
# FILES:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern:OVERRIDES = ""

# external-pattern
# PACKAGES += "${PN}-pattern"
# SUMMARY:${PN}-pattern = "MACHINE use"
# FILES:${PN}-pattern = ""
# RDEPENDS:${PN}-pattern = ""
# RDEPENDS:${PN}-pattern:OVERRIDES = ""

FILES:${PN} = ""
RDEPENDS:${PN} = ""

####################

PACKAGES += "${PN}-core"
SUMMARY:${PN}-core = "MACHINE use"
FILES:${PN}-core = ""
RDEPENDS:${PN}-core = " \
${INTERNAL_PG}-initramfs \
${INTERNAL_PG}-modules \
kernel-base \
kernel-dev \
kernel-image \
kernel-image-bzimage \
kernel-modules \
kernel-vmlinux \
"
# kernel-firmware-%s

####################

PACKAGES += "${PN}-core-sdk"
SUMMARY:${PN}-core-sdk = "MACHINE use"
FILES:${PN}-core-sdk = ""
RDEPENDS:${PN}-core-sdk = " \
${PN}-core \
"

####################

PACKAGES += "${PN}-full"
SUMMARY:${PN}-full = "MACHINE use"
FILES:${PN}-full = ""
RDEPENDS:${PN}-full = " \
${PN}-core \
"

####################

# Note: required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

PACKAGES += "${INTERNAL_PG}-initramfs"
SUMMARY:${INTERNAL_PG}-initramfs = "internal packagegroup use"
FILES:${INTERNAL_PG}-initramfs = ""
RDEPENDS:${INTERNAL_PG}-initramfs = ""
# build-in
# kernel-module-tpm # kernel-module-tpm-tis kernel-module-tpm-tis-core kernel-module-tpm-atmel
# kernel-module-tpm-crb kernel-module-tpm-i2c-atmel kernel-module-tpm-i2c-infineon kernel-module-tpm-i2c-nuvoton
# kernel-module-tpm-infineon kernel-module-tpm-nsc kernel-module-tpm-st33zp24 kernel-module-tpm-st33zp24-i2c
# kernel-module-tpm-st33zp24-spi kernel-module-tpm-tis-i2c kernel-module-tpm-tis-i2c-cr50 kernel-module-tpm-tis-spi
# kernel-module-tpm-vtpm-proxy

####################

PACKAGES += "${INTERNAL_PG}-modules"
SUMMARY:${INTERNAL_PG}-modules = "internal packagegroup use"
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
# build-in
# kernel-module-configs kernel-module-xt-addrtype kernel-module-ip-vs kernel-module-ip-vs-rr kernel-module-ip-vs-sh kernel-module-ip-vs-wrr
# kernel-module-kheaders kernel-module-vxlan kernel-module-xt-physdev kernel-module-nf-conntrack kernel-module-ipt-masquerade kernel-module-nf-conntrack-ipv4
# kernel-module-nf-defrag-ipv4 kernel-module-crc-ccitt kernel-module-dm-integrity kernel-module-btrfs kernel-module-erofs kernel-module-xfs
# kernel-module-aes-generic kernel-module-md5 kernel-module-cbc kernel-module-sha256-generic kernel-module-xts kernel-module-nf-defrag-ipv6
