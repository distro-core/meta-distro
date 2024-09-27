SUMMARY = "Distro WSL"
DESCRIPTION = "Distro WSL"
HOMEPAGE = "https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro"

# cd /path/to/rootfs
# tar --numeric-owner --absolute-names -c  * | gzip --best > ../install.tar.gz

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
  file://oobe.sh \
  file://terminal-profile.ico \
  file://terminal-profile.json \
  file://wsl-distribution.conf \
  file://wsl.conf \
"

do_install() {
  install -D -m 0644 ${S}/wsl-distribution.conf ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%DISTRO%@${DISTRO}@g" ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%SYSCONFDIR%@${sysconfdir}@g" ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%NONARCH_BASE_LIBDIR%@${nonarch_base_libdir}@g" ${D}${sysconfdir}/wsl-distribution.conf

  install -D -m 0644 ${S}/wsl.conf ${D}${sysconfdir}/wsl.conf
  sed -i -e "s@%SYSCONFDIR%@${sysconfdir}@g" ${D}${sysconfdir}/wsl.conf

  install -D -m 0755 ${S}/oobe.sh ${D}${sysconfdir}/oobe.sh
  sed -i -e "s@%SBINDIR%@${sbindir}@g" ${D}${sysconfdir}/oobe.sh

  install -D -m 0644 ${S}/terminal-profile.ico ${D}/${nonarch_base_libdir}/wsl/terminal-profile.ico
  install -D -m 0644 ${S}/terminal-profile.json ${D}/${nonarch_base_libdir}/wsl/terminal-profile.json
}
