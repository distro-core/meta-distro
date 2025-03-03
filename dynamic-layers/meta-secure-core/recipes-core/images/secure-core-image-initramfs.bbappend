# Do not perform sota operations

IMAGE_CLASSES:remove = "image_repo_manifest"

IMAGE_FSTYPES:remove = "ostreepush garagesign garagecheck ostree ostree.tar.gz ota ota.tar.gz ota-btrfs ota-ext4"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
