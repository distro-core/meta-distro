# meta-tegra
INITRAMFS_FSTYPES:remove:tegra = "cpio.gz.cboot"

# no initramfs
do_install:wsl-amd64() {
  true
}

# no initramfs
do_install:wsl-arm64() {
  true
}


