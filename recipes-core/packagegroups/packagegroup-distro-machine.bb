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
INTERNAL_PG = "${PN}-internal"

EXCLUDE_FROM_WORLD = "1"

inherit packagegroup

################################################################################
# LICENSE open source packages
################################################################################

# PACKAGES += "${PN}-pattern"
# SUMMARY:${PN}-pattern = "DISTRO use"
# FILES:${PN}-pattern = ""
# RDEPENDS:${PN}-pattern = ""
# RDEPENDS:${PN}-pattern:OVERRIDES = ""

FILES:${PN} = ""
RDEPENDS:${PN} = ""

####################

PACKAGES += "${PN}-core"
SUMMARY:${PN}-core = "Packagegroup for images"
DESCRIPTION:${PN}-core = "Description"
FILES:${PN}-core = ""
RDEPENDS:${PN}-core = " \
${INTERNAL_PG}-initramfs \
${INTERNAL_PG}-modules \
kernel-base \
kernel-dev \
kernel-image \
kernel-modules \
kernel-vmlinux \
"
# kernel-firmware-%s
RDEPENDS:${PN}-core:append:corei7-64-intel-common = " kernel-image-bzimage"

####################

PACKAGES += "${PN}-core-sdk"
SUMMARY:${PN}-core-sdk = "Packagegroup for images"
DESCRIPTION:${PN}-core-sdk = "Description"
FILES:${PN}-core-sdk = ""
RDEPENDS:${PN}-core-sdk = " \
${PN}-core \
"

####################

PACKAGES += "${PN}-full"
SUMMARY:${PN}-full = "Packagegroup for images"
DESCRIPTION:${PN}-full = "Description"
FILES:${PN}-full = ""
RDEPENDS:${PN}-full = " \
${PN}-core \
"

############################################################
# LOCAL packagegroups are for grouping of packages into
# a collection of similar or related packages
############################################################

# PACKAGES += "${INTERNAL_PG}-pattern"
# SUMMARY:${PN}-pattern = "Packagegroup for internal organization"
# DESCRIPTION:${PN}-pattern = "Packagegroup for internal organizaton"
# FILES:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern:OVERRIDES = ""

# Note: Required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

PACKAGES += "${INTERNAL_PG}-initramfs"
SUMMARY:${PN}-initramfs = "Packagegroup for internal organization"
DESCRIPTION:${PN}-initramfs = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-initramfs = ""
RDEPENDS:${INTERNAL_PG}-initramfs = ""

####################

# Note: Limited list of modules to install (prefer to kernel-modules); to specify
# the modules that are included in images over "everything"

PACKAGES += "${INTERNAL_PG}-modules"
SUMMARY:${PN}-modules = "Packagegroup for internal organization"
DESCRIPTION:${PN}-modules = "Packagegroup for internal organizaton"
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
