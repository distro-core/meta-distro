require recipes-kernel/linux/distro-linux-common.inc

KMETA = "kernel-meta"

# TODO: edit branch= to reflect meta-tegra/recipes-kernel/linux/linux-tegra%.bb
SRC_URI += "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-5.10;destsuffix=${KMETA};protocol=https"

# TODO: SRCREV_meta to reflect commit-id from the kmeta appended to SRC_URI
SRCREV_meta = "a26c1def6dceccb96ab9a707072d22e75888eda9"
