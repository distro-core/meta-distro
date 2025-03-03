# File: distro-image-usrmerge.bbclass
# SPDX-License-Identifier: MIT

# Setup for usrmerge and sota variants. The initial preprocess prepares the rootfs with softlinks
# to support systemd-tmpfiles initialization. Softlinks are created such that initialization can
# occur from /usr/share/factory/ into the final locations. The magic can occur during initramfs
# calling ostree-prepare-root, when the image is sota enabled.

USR_SHARE_FACTORY_TMPFILES_CONF ??= "00-boot-${BPN}.conf"

require conf/image-uefi.conf

# rootfs_preprocess

# rootfs prepare process uses internal package-management scripting to load the rootfs from *.rpm
# previously created during the bitbake process. the preprocess makes softlinks in the rootfs
# before any packages are installed from *.rpm, placing the binaries and configs into
# ${datadir}/factory${localstatedir} which systemd can populate at runtime.

rootfs_preprocess_usr_share_factory() {
    # bbwarn "rootfs_preprocess_usr_share_factory ${IMAGE_ROOTFS}"

    # /usr/local -> /usr/usrlocal (not volatile)
    install -d -m 0755 ${IMAGE_ROOTFS}${exec_prefix}/usrlocal
    ln -sfr ${IMAGE_ROOTFS}${exec_prefix}/usrlocal ${IMAGE_ROOTFS}${exec_prefix}/local

    # /var -> /usr/share/factory/var
    install -d -m 0755 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir} ${IMAGE_ROOTFS}${localstatedir}

    # /home -> /usr/share/factory/var/rootdirs/home
    install -d -m 0755 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/home
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/home ${IMAGE_ROOTFS}/home

    # /opt -> /usr/share/factory/var/rootdirs/opt
    install -d -m 0755 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/opt
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/opt ${IMAGE_ROOTFS}/opt

    # /mnt -> /usr/share/factory/var/rootdirs/mnt
    install -d -m 0755 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/mnt
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/mnt ${IMAGE_ROOTFS}/mnt

    # /media -> /usr/share/factory/var/rootdirs/media
    install -d -m 0755 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/media
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/media ${IMAGE_ROOTFS}/media

    # /srv -> /usr/share/factory/var/rootdirs/srv
    install -d -m 0755 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/srv
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/rootdirs/srv ${IMAGE_ROOTFS}/srv

    # /root -> /usr/share/factory/var/roothome
    install -d -m 0700 ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/roothome
    ln -sfr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/roothome ${IMAGE_ROOTFS}/root

    # /bin -> /usr/bin, /sbin -> /usr/sbin
    # ln -sfr ${IMAGE_ROOTFS}${bindir} ${IMAGE_ROOTFS}/bin
    # ln -sfr ${IMAGE_ROOTFS}${sbindir} ${IMAGE_ROOTFS}/sbin

    # /etc/tmpfiles.d
    install -d -m 0755 ${IMAGE_ROOTFS}${sysconfdir}/tmpfiles.d
    install -d -m 0755 ${IMAGE_ROOTFS}${nonarch_libdir}/tmpfiles.d

	# if [ "${OSTREE_BOOTLOADER}" = "syslinux" ]; then
    #     if [ -n "${IMAGE_ROOTFS}" ]; then
	# 	      mkdir -p ${IMAGE_ROOTFS}/boot/extlinux
	# 	      cp -f ${IMAGE_ROOTFS}/boot/loader/syslinux.cfg ${OTA_SYSROOT}/boot/extlinux/extlinux.cfg
    #     fi
    # fi
}
# prepended to execute early in order of operations
ROOTFS_PREPROCESS_COMMAND:prepend = "rootfs_preprocess_usr_share_factory;"

# rootfs_postinstall, before QA of do_rootfs

# rootfs_postinstall_usr_share_factory() {
#     # bbwarn "rootfs_postinstall_usr_share_factory ${IMAGE_ROOTFS}"
# }
# ROOTFS_POSTINSTALL_COMMAND:append = "rootfs_postinstall_usr_share_factory;"

# rootfs_postprocess, after QA of do_rootfs

# rootfs_postprocess_usr_share_factory() {
#     # bbwarn "rootfs_postprocess_usr_share_factory ${IMAGE_ROOTFS}"
# }
# ROOTFS_POSTPROCESS_COMMAND:append = "rootfs_postprocess_usr_share_factory;"

# rootfs_postuninstall

rootfs_postuninstall_usr_share_factory() {
    # bbwarn "rootfs_postuninstall_usr_share_factory ${IMAGE_ROOTFS}"

    # remove symlink to /var and create
    rm -f ${IMAGE_ROOTFS}${localstatedir}
    install -d -m 0755 ${IMAGE_ROOTFS}${localstatedir}

    # remove symlink /usr/share/factory/var/ replace as symlink /var/rootdirs/
    if [ -h ${IMAGE_ROOTFS}/home ]; then
        rm -f ${IMAGE_ROOTFS}/home
        ln -sfr ${IMAGE_ROOTFS}${localstatedir}/rootdirs/home ${IMAGE_ROOTFS}/home
    fi
    if [ -h ${IMAGE_ROOTFS}/media ]; then
        rm -f ${IMAGE_ROOTFS}/media
        ln -sfr ${IMAGE_ROOTFS}${localstatedir}/rootdirs/media ${IMAGE_ROOTFS}/media
    fi
    rm -fr ${IMAGE_ROOTFS}/mnt
    mkdir -p ${IMAGE_ROOTFS}/mnt
    # if [ -h ${IMAGE_ROOTFS}/mnt ]; then
    #     rm -f ${IMAGE_ROOTFS}/mnt
    #     ln -sfr ${IMAGE_ROOTFS}${localstatedir}/rootdirs/mnt ${IMAGE_ROOTFS}/mnt
    # fi
    if [ -h ${IMAGE_ROOTFS}/opt ]; then
        rm -f ${IMAGE_ROOTFS}/opt
        ln -sfr ${IMAGE_ROOTFS}${localstatedir}/rootdirs/opt ${IMAGE_ROOTFS}/opt
    fi
    if [ -h ${IMAGE_ROOTFS}/root ]; then
        rm -f ${IMAGE_ROOTFS}/root
        install -d -m 0700 ${IMAGE_ROOTFS}/root
    fi
    if [ -h ${IMAGE_ROOTFS}/srv ]; then
        rm -f ${IMAGE_ROOTFS}/srv
        ln -sfr ${IMAGE_ROOTFS}${localstatedir}/rootdirs/srv ${IMAGE_ROOTFS}/srv
    fi

    # restore /usr/share/factory/var/{local,sota} to /var
    if [ -d ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/local ]; then
        mv -f ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/local ${IMAGE_ROOTFS}${localstatedir}
    fi
    if [ -d ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/sota ]; then
        mv -f ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/sota ${IMAGE_ROOTFS}${localstatedir}
    fi

    # restore unexpected /usr/share/factory/etc/* to /etc
    install -d -m 0755 ${IMAGE_ROOTFS}${sysconfdir}
    if [ -d ${IMAGE_ROOTFS}${datadir}/factory${sysconfdir} ]; then
        if [ -n "${IMAGE_ROOTFS}${datadir}/factory${sysconfdir}/*" ]; then
            cp -frd -t ${IMAGE_ROOTFS}${sysconfdir} ${IMAGE_ROOTFS}${datadir}/factory${sysconfdir}/*
        fi
    fi
    rm -fr ${IMAGE_ROOTFS}${datadir}/factory${sysconfdir}

    # bbwarn "copy of /efi to ${datadir}/factory/efi"
    if [ -d ${IMAGE_ROOTFS}/efi ]; then
        mkdir -p ${IMAGE_ROOTFS}${datadir}/factory/efi
        cp -frd -t ${IMAGE_ROOTFS}${datadir}/factory/efi ${IMAGE_ROOTFS}/efi/* || true
        # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
        cat <<EOF >>${IMAGE_ROOTFS}${nonarch_libdir}/tmpfiles.d/${USR_SHARE_FACTORY_TMPFILES_CONF}
C+! /efi - - - - ${datadir}/factory/efi
# L+! ${sysconfdir}/tmpfiles.d/00-boot-${BPN}-00.conf - - - - /dev/null
EOF
    fi

    # bbwarn "copy of /boot to ${datadir}/factory/boot"
    if [ -d ${IMAGE_ROOTFS}/boot ]; then
        mkdir -p ${IMAGE_ROOTFS}${datadir}/factory/boot
        cp -frd -t ${IMAGE_ROOTFS}${datadir}/factory/boot ${IMAGE_ROOTFS}/boot/* || true
        # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
        cat <<EOF >${IMAGE_ROOTFS}${nonarch_libdir}/tmpfiles.d/${USR_SHARE_FACTORY_TMPFILES_CONF}
C+! /boot - - - - ${datadir}/factory/boot
# L+! ${sysconfdir}/tmpfiles.d/00-boot-${BPN}-01.conf - - - - /dev/null
EOF
    fi

    # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
    cat <<EOF >>${IMAGE_ROOTFS}${nonarch_libdir}/tmpfiles.d/${USR_SHARE_FACTORY_TMPFILES_CONF}
C+! ${localstatedir} - - - - ${datadir}/factory${localstatedir}
R! /run - - - - -
D! /run 0755 root root 0 -
D! /run/lock 0755 root root 0 -
L+! ${localstatedir}/run - - - - /run
L+! ${localstatedir}/lock - - - - /run/lock
# L+! ${sysconfdir}/tmpfiles.d/00-boot-${BPN}-02.conf - - - - /dev/null
EOF

    # remove known deplorables
    rm -fr ${IMAGE_ROOTFS}/nonexistent
    rm -fr ${IMAGE_ROOTFS}${EFI_PREFIX}/*.pid
    rm -fr ${IMAGE_ROOTFS}${datadir}/factory${localstatedir}/cache/*
    # rm -f ${IMAGE_ROOTFS}/bin
    # rm -f ${IMAGE_ROOTFS}/sbin

    # capture boot artifacts
    # install -d ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-boot
    # cp -frd -t ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}-boot ${IMAGE_ROOTFS}${EFI_PREFIX}/*

    # image.bbclass
    # find ${IMAGE_ROOTFS} -exec touch --no-dereference --date=@${REPRODUCIBLE_TIMESTAMP_ROOTFS} '{}' ';'
}
ROOTFS_POSTUNINSTALL_COMMAND:append = " rootfs_postuninstall_usr_share_factory;"

# image_postprocess

# image_postprocess_usr_share_factory() {
#     # bbwarn "image_postprocess_usr_share_factory ${IMAGE_ROOTFS}"
# }
# IMAGE_POSTPROCESS_COMMAND:append = " image_postprocess_usr_share_factory;"
