FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# https://www.freedesktop.org/software/systemd/man/latest/loader.conf.html
# https://uapi-group.org/specifications/specs/boot_loader_specification/
# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-secure-boot-key-creation-and-management-guidance?view=windows-11

# ostree=deploy softlinks created at classes/image_types_ota_extend.bbclass
# keys are placed at loader-prefix/keys/KEYDIR (eg, auto)

# UEFI keys are already generated and available. Production systems should obtain keys
# from secure storage. IMAGE_SECUREBOOT_KEYS_DIR environment variable is set to the
# location of the UEFI keys.

RCONFLICTS:${PN} += "grub-bootconf"

inherit image_types_partition

ROOT = ""

LOADER_PREFIX ?= "${EFI_PREFIX}/loader"

do_install:append() {

    cat <<EOF >${SYSTEMD_BOOT_CFG}
default default-target*
timeout ${SYSTEMD_BOOT_TIMEOUT}
console-mode keep
editor off
auto-entries off
auto-firmware off
secure-boot-enroll manual
EOF

    cat <<EOF >${S}/default-target-0.conf
title ${DISTRO_NAME} ${DISTRO_VERSION} ${DISTRO}.0
sort-key 10
options ${APPEND} ostree=/ostree/${DISTRO}.0
linux ${KERNEL_IMAGETYPE}-${MACHINE}${KERNEL_ARTIFACT_BIN_EXT}
initrd ${INITRAMFS_IMAGE}-${MACHINE}.${INITRAMFS_FSTYPES}
EOF

    cat <<EOF >${S}/default-target-1.conf
title ${DISTRO_NAME} ${DISTRO_VERSION} ${DISTRO}.1
sort-key 12
options ${APPEND} ostree=/ostree/${DISTRO}.1
linux ${KERNEL_IMAGETYPE}-${MACHINE}${KERNEL_ARTIFACT_BIN_EXT}
initrd ${INITRAMFS_IMAGE}-${MACHINE}.${INITRAMFS_FSTYPES}
EOF

    # loader conf files
    install -d -m 0755 ${D}${LOADER_PREFIX}
    install -d -m 0755 ${D}${LOADER_PREFIX}/entries

    # generated at systemd-boot-cfg.bbclass
    rm -f ${D}${LOADER_PREFIX}/entries/boot.conf

    install -D -m 0644 ${SYSTEMD_BOOT_CFG} ${D}${LOADER_PREFIX}/loader.conf
    install -D -m 0644 ${S}/default-target-0.conf ${D}${LOADER_PREFIX}/entries/default-target-0+3-0.conf
    install -D -m 0644 ${S}/default-target-1.conf ${D}${LOADER_PREFIX}/entries/default-target-1.conf

    if [ -n "${IMAGE_SECUREBOOT_KEYS_DIR}" ]; then
        install -d -m 0755 ${D}${LOADER_PREFIX}/keys
        install -d -m 0755 ${D}${LOADER_PREFIX}/keys/auto
        for key in db KEK PK; do
            if [ -e ${IMAGE_SECUREBOOT_KEYS_DIR}/${key}.auth ]; then
                install -D -m 0644 ${IMAGE_SECUREBOOT_KEYS_DIR}/${key}.auth ${D}${LOADER_PREFIX}/keys/auto/${key}.auth
            else
                bbfatal "IMAGE_SECUREBOOT_KEYS_DIR missing ${key}.auth"
            fi
            if [ -e ${IMAGE_SECUREBOOT_KEYS_DIR}/${key}.crt ]; then
                install -D -m 0644 ${IMAGE_SECUREBOOT_KEYS_DIR}/${key}.crt ${D}${LOADER_PREFIX}/keys/auto/${key}.crt
            else
                bbfatal "IMAGE_SECUREBOOT_KEYS_DIR missing ${key}.crt"
            fi
        done
    fi
}

FILES:${PN} += "${LOADER_PREFIX}/"

inherit deploy
do_deploy() {
    install -d ${DEPLOYDIR}/bootconf
    cp -frd -t ${DEPLOYDIR}/bootconf ${D}${LOADER_PREFIX}/*
}
addtask deploy after do_install before do_package
