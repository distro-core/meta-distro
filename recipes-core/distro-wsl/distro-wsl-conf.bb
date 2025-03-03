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
file://wsl-instance.sh \
file://fstab \
"

S = "${WORKDIR}"

RDEPENDS:${PN} = "bash"

WSL_USER_UID = "1000"
WSL_USER_GID = "1000"
WSL_USER_NAME = "wsl"
WSL_DATADIR = "${nonarch_libdir}/wsl"

inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = " \
--uid ${WSL_USER_GID} --gid ${WSL_USER_GID} --home-dir /home/${WSL_USER_NAME} --create-home --shell /bin/bash --groups adm,audio,cdrom,dialout,docker,floppy,netdev,sudo,dip,plugdev,video ${WSL_USER_NAME} ; \
"

GROUPADD_PARAM:${PN} = " \
adm ; audio ; cdrom ; dialout ; docker ; floppy ; netdev ; sudo ; dip ; plugdev ; video ; \
--gid ${WSL_USER_GID} ${WSL_USER_NAME} ; \
"

do_install() {

  install -D -m 0755 ${S}/wsl-instance.sh ${D}${sysconfdir}/profile.d/wsl-instance.sh
  install -D -m 0644 ${S}/wsl-distribution.conf ${D}${sysconfdir}/wsl-distribution.conf
  install -D -m 0644 ${S}/wsl.conf ${D}${sysconfdir}/wsl.conf
  install -D -m 0644 ${S}/fstab ${D}${sysconfdir}/fstab

  install -d -m 0755 ${D}${WSL_DATADIR}
  install -d -m 0755 ${D}${WSL_DATADIR}/drivers
  install -d -m 0755 ${D}${WSL_DATADIR}/lib
  install -d -m 0755 ${D}${sysconfdir}/ld.so.conf.d
  install -d -m 0755 ${D}/init
  # install -d -m 0755 ${D}/mnt/wsl
  # install -d -m 0755 ${D}/mnt/wslg

  install -D -m 0755 ${S}/oobe.sh ${D}${WSL_DATADIR}/oobe.sh
  install -D -m 0644 ${S}/terminal-profile.ico ${D}${WSL_DATADIR}/terminal-profile.ico
  install -D -m 0644 ${S}/terminal-profile.json ${D}${WSL_DATADIR}/terminal-profile.json

  for file in \
    ${D}${sysconfdir}/wsl-distribution.conf \
    ${D}${sysconfdir}/wsl.conf \
    ${D}${WSL_DATADIR}/oobe.sh \
    ; do
    sed -i -e "s@%DISTRO%@${DISTRO}@g" $file
    sed -i -e "s@%DISTRO_VERSION%@${DISTRO_VERSION}@g" $file
    sed -i -e "s@%WSL_DATADIR%@${WSL_DATADIR}@g" $file
    sed -i -e "s@%WSL_USER_GID%@${WSL_USER_GID}@g" $file
    sed -i -e "s@%WSL_USER_NAME%@${WSL_USER_NAME}@g" $file
    sed -i -e "s@%WSL_USER_UID%@${WSL_USER_UID}@g" $file
  done

}

CONFFILES:${PN} += "${sysconfdir}/fstab"

FILES:${PN} = "${WSL_DATADIR} ${sysconfdir} /init /home/${WSL_USER_NAME}"
