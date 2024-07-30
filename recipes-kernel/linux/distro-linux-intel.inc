FILESEXTRAPATHS:prepend := "${THISDIR}/linux:"

# .cfg files applied in append order
SRC_URI:append = " \
${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'file://selinux.cfg', '', d)} \
file://lxc.cfg \
file://ebtables.cfg \
file://vswitch.cfg \
file://xt-checksum.cfg \
file://serial-fintek.cfg \
file://devicemapper.cfg \
file://fs-btrfs.cfg \
file://fs-erofs.cfg \
file://fs-ext4.cfg \
file://fs-network.cfg \
file://fs-overlay.cfg \
file://fs-common.cfg \
file://dmcrypt.cfg \
file://common-canbus.cfg \
file://common-crypto.cfg \
file://common-kernel.cfg \
file://common-network.cfg \
file://common-security.cfg \
file://common-tpm.cfg \
file://common-usbbus.cfg \
file://common-wireless.cfg \
"
# SRC_URI += " file://defconfig.cfg"

# meta-clang
OBJCOPY:toolchain-clang = "${HOST_PREFIX}objcopy"

# meta-clang
SRC_URI:append:toolchain-clang = "file://lto.cfg"

do_compile:prepend:toolchain-clang() {
	export LLVM_IAS=1
}

do_compile_kernelmodules:prepend:toolchain-clang() {
	export LLVM_IAS=1
}

INSANE_SKIP:${PN}-src += "buildpaths"
