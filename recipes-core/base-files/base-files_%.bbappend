FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fstab file://issue.distro file://profile.sh"

BASEFILESISSUEINSTALL = "bbnote 'BASEFILESISSUEINSTALL'"

dirs755 += "/efi /var/lib /var/log /var/log/audit"

do_install_basefilesissue() {
    bbnote 'BASEFILESISSUEINSTALL'
}

do_install:append() {

    install -D -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab
    install -D -m 0644 ${WORKDIR}/issue.distro ${D}${sysconfdir}/issue
    install -D -m 0644 ${WORKDIR}/issue.distro ${D}${sysconfdir}/issue.net
    install -D -m 0644 ${WORKDIR}/profile.sh ${D}${sysconfdir}/profile.d/00-${PN}.sh

    # mask unwanted automounts from initramfs-module-core:ostree at /media

    # install -d -m 0755 ${D}${sysconfdir}/systemd/system
    # ln -sf /dev/null ${D}${sysconfdir}/systemd/system/run-media-${FSYS_DEV_NAME_ESP}-sda1.mount
    # ln -sf /dev/null ${D}${sysconfdir}/systemd/system/run-media-${FSYS_DEV_NAME_XBOOTLDR}-sda2.mount

    # fstab filesystem entries
    # sota mounts from initramfs-module-core:ostree

    # printf "#%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "UUID=${FSYS_DEV_UUID_ROOT}" "/" "${FSYS_DEV_TYPE_ROOT}" "remount,rw,noatime" 0 1 >> ${D}${sysconfdir}/fstab
    # printf "#%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "UUID=${FSYS_DEV_UUID_ESP_FSTAB}" "/efi" "${FSYS_DEV_TYPE_ESP}" "remount,rw,noatime,nodev,nosuid,noexec" 0 0 >> ${D}${sysconfdir}/fstab
    # printf "#%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "UUID=${FSYS_DEV_UUID_XBOOTLDR}" "/boot" "${FSYS_DEV_TYPE_XBOOTLDR}" "remount,rw,noatime,nodev,nosuid,noexec" 0 0 >> ${D}${sysconfdir}/fstab

    # printf "%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "UUID=${FSYS_DEV_UUID_LIB}" "/var/lib" "${FSYS_DEV_TYPE_LIB}" "auto,nofail,rw,noatime,nodev,nosuid" 0 1 >> ${D}${sysconfdir}/fstab
    # printf "%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "UUID=${FSYS_DEV_UUID_LOG}" "/var/log" "${FSYS_DEV_TYPE_LOG}" "auto,nofail,rw,noatime,nodev,nosuid,noexec" 0 1 >> ${D}${sysconfdir}/fstab
    # printf "%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "UUID=${FSYS_DEV_UUID_AUDIT}" "/var/log/audit" "${FSYS_DEV_TYPE_AUDIT}" "auto,nofail,rw,noatime,nodev,nosuid,noexec" 0 2 >> ${D}${sysconfdir}/fstab

    printf "#%-42s  %-14s  %-8s  %-70s  %-1d  %-1d\n" "LABEL=USBDRIVE" "/mnt" "vfat" "auto,nofail,ro,noatime,nodev,nosuid,noexec" 0 0 >> ${D}${sysconfdir}/fstab

    # pkg_* functionality creates any needed /var/volatile paths
    # rm -fr ${D}${localstatedir}/volatile
}

FILES:${PN} += "${sysconfdir}/profile.d/00-${PN}.sh ${sysconfdir}/systemd/system/"
