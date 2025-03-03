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

S = "${WORKDIR}"

RDEPENDS:${PN} = "bash"

inherit useradd

WSL_USER_GID = "999"
WSL_USER_UID = "999"
WSL_USER_NAME = "wsl-user"

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "-g ${WSL_USER_GID} ${WSL_USER_NAME} ;"

USERADD_PARAM:${PN} = "-r -m -d /home/${WSL_USER_NAME} -G adm,cdrom,sudo,dip,plugdev -s /bin/bash -g ${WSL_USER_GID} -u ${WSL_USER_UID} ${WSL_USER_NAME} ;"

inherit extrausers

EXTRA_USERS_PARAMS = "usermod -P password ${WSL_USER_NAME}"

do_install() {
  install -D -m 0644 ${S}/wsl-distribution.conf ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%DISTRO_NAME%@${DISTRO_NAME}@g" ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%DATADIR%@${datadir}/wsl@g" ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%WSL_USER_NAME%@${WSL_USER_NAME}@g" ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%WSL_USER_GID%@${WSL_USER_GID}@g" ${D}${sysconfdir}/wsl-distribution.conf
  sed -i -e "s@%WSL_USER_UID%@${WSL_USER_UID}@g" ${D}${sysconfdir}/wsl-distribution.conf

  install -D -m 0644 ${S}/wsl.conf ${D}${sysconfdir}/wsl.conf
  sed -i -e "s@%WSL_USER_NAME%@${WSL_USER_NAME}@g" ${D}${sysconfdir}/wsl.conf
  sed -i -e "s@%WSL_USER_GID%@${WSL_USER_GID}@g" ${D}${sysconfdir}/wsl.conf
  sed -i -e "s@%WSL_USER_UID%@${WSL_USER_UID}@g" ${D}${sysconfdir}/wsl.conf

  install -D -m 0755 ${S}/oobe.sh ${D}${datadir}/wsl/oobe.sh
  sed -i -e "s@%DISTRO_NAME%@${DISTRO_NAME}@g" ${D}${datadir}/wsl/oobe.sh
  sed -i -e "s@%WSL_USER_NAME%@${WSL_USER_NAME}@g" ${D}${datadir}/wsl/oobe.sh
  sed -i -e "s@%WSL_USER_GID%@${WSL_USER_GID}@g" ${D}${datadir}/wsl/oobe.sh
  sed -i -e "s@%WSL_USER_UID%@${WSL_USER_UID}@g" ${D}${datadir}/wsl/oobe.sh

  install -D -m 0644 ${S}/terminal-profile.ico ${D}/${datadir}/wsl/terminal-profile.ico
  install -D -m 0644 ${S}/terminal-profile.json ${D}/${datadir}/wsl/terminal-profile.json
}

FILES:${PN} = "${sysconfdir}/ ${datadir}/ /home/"
