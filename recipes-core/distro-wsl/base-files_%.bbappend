do_install:append:wsl-amd64() {
  rm -f ${D}${sysconfdir}/fstab
}

do_install:append:wsl-arm64() {
  rm -f ${D}${sysconfdir}/fstab
}
