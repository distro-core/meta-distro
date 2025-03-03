FILESEXTRAPATHS:prepend := "${THISDIR}/linux:"

# Kernel is built with a number of features enabled, even when userspace software
# is not present. Other features are build in based upon presence of flags in
# DISTRO_FEAUTURES and MACHINE_FEATURES.

# meta-intel
INTEL_COMMON_PACKAGE_ARCH ??= "null"

require recipes-kernel/linux/distro-sierra-wireless-mbpl.inc

# KERNEL_FEATURES enable, preferred for different kernel versions use of yocto-kernel-cache
# https://docs.yoctoproject.org/kernel-dev/advanced.html ; do not duplicate entries for KTYPE.

KERNEL_FEATURES += " \
cfg/efi.scc \
cfg/fs/btrfs.scc \
cfg/fs/devtmpfs.scc \
cfg/fs/ext4.scc \
cfg/fs/vfat.scc \
cfg/net/bridge.scc \
cfg/net/ip_nf.scc \
cfg/net/ip6_nf.scc \
cfg/net/ipsec.scc \
cfg/net/ipsec6.scc \
cfg/net/ipv6.scc \
cfg/vesafb.scc \
cgl/features/audit/audit.scc \
cgl/features/quota/quota.scc \
cgl/features/selinux/selinux.scc \
features/bluetooth/bluetooth-usb.scc \
features/bluetooth/bluetooth-vhci.scc \
features/debug/printk.scc \
features/hostapd/hostapd.scc \
features/i2c/i2c.scc \
features/i2c/i2cdev.scc \
features/igb/igb.scc \
features/iwlwifi/iwlwifi.scc \
features/kvm/kvm.scc \
features/kvm/qemu-kvm-enable.scc \
features/mac80211/mac80211.scc \
features/namespaces/namespaces.scc \
features/netfilter/netfilter.scc \
features/nf_tables/nf_tables.scc \
features/ocicontainer/ocicontainer.scc \
features/overlayfs/overlayfs.scc \
features/spi/spi.scc \
features/spi/spidev.scc \
features/usb-net/usb-net.scc \
features/usb/usb-gadgets.scc \
features/usb/usb-raw-gadget.scc \
features/vrf/vrf.scc \
features/vxlan/vxlan-enable.scc \
features/wifi/wifi-all.scc \
"
KERNEL_FEATURES:append:${INTEL_COMMON_PACKAGE_ARCH} = " \
features/tpm/tpm.scc \
"
# features/can/can.scc
# features/vfat/vfat.scc

# SRC_URI specifc kernel config fragments
SRC_URI += " \
file://can-bus.cfg \
file://device-mapper.cfg \
file://fs-btrfs.cfg \
file://fs-common.cfg \
file://fs-erofs.cfg \
file://fs-ext4.cfg \
file://fs-network.cfg \
file://kernel-config.cfg \
"
SRC_URI:append:${INTEL_COMMON_PACKAGE_ARCH} = " \
file://serial-fintek.cfg \
"

# meta-clang
OBJCOPY:toolchain-clang = "${HOST_PREFIX}objcopy"

# meta-clang
SRC_URI:append:toolchain-clang = " file://lto.cfg"

do_compile:prepend:toolchain-clang() {
	export LLVM_IAS=1
}

do_compile_kernelmodules:prepend:toolchain-clang() {
	export LLVM_IAS=1
}

INSANE_SKIP:${PN}-src += "buildpaths"
