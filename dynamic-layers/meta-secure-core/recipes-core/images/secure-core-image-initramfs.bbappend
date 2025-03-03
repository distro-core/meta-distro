# Do not perform sota operations

IMAGE_CLASSES:remove:sota = "image_repo_manifest"

IMAGE_FSTYPES:remove:sota = "ostreepush garagesign garagecheck ostree ostree.tar.gz ota ota.tar.gz ota-btrfs ota-ext4"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

PACKAGE_INSTALL:append = " os-release-initrd"
