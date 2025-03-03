# conf/machine/include/machine-common.inc

# Used to define common build settings

# inherit in image recipes (per image)
# INHERIT += " image_types_partition"

KERNEL_IMAGE_MAXSIZE = "32768"
# KERNEL_IMAGETYPE = "bzImage"
KERNEL_ARTIFACT_BIN_EXT = ""

# KERNEL_SPLIT_MODULES = "1"
# KERNEL_PACKAGE_NAME = "kernel"
KERNEL_VERSION_NAME = ""
# KERNEL_MODULE_PACKAGE_PREFIX = ""
KERNEL_MODULE_PACKAGE_SUFFIX = ""

IMAGE_NAME_SUFFIX = ""
# IMAGE_MACHINE_SUFFIX = ""

IMAGE_OVERHEAD_FACTOR = "1.2"
# maximum size of the rootfs KiB (4GiB=4194304, 8GiB=8388608, 16GiB=16777216)
IMAGE_ROOTFS_MAXSIZE = "16777216"
# remove extra space added by rootfs_rpm.bbclass
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains('PACKAGE_INSTALL', 'dnf', ' - 102400', '', d)}"

# EXTRA_IMAGEDEPENDS:append = " ovmf"
# OVMF_SECURE_BOOT_EXTRA_FLAGS:x86-64 = "-D SMM_REQUIRE"

# ---
