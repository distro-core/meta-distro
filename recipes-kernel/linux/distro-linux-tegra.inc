FILESEXTRAPATHS:prepend := "${THISDIR}/linux:"

# .cfg files applied in append order
SRC_URI:append = " \
${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'file://selinux.cfg', '', d)} \
file://devicemapper.cfg \
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
