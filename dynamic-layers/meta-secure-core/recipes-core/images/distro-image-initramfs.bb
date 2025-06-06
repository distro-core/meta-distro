DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."
LICENSE = "MIT"

ROOTFS_BOOTSTRAP_INSTALL:append = " \
    ${@bb.utils.contains("DISTRO_FEATURES", "tpm2", \
                         "packagegroup-tpm2-initramfs", "", d)} \
    ${@bb.utils.contains("DISTRO_FEATURES", "ima", \
                         "packagegroup-ima-initramfs", "", d)} \
    ${@bb.utils.contains("DISTRO_FEATURES", "luks", \
                         "packagegroup-luks-initramfs", "", d)} \
    ${@bb.utils.contains("DISTRO_FEATURES", "sota", \
                         "ostree-switchroot", "", d)} \
"
PACKAGE_INSTALL = " \
    os-release-initrd \
    initrdscripts-secure-core \
    ${VIRTUAL-RUNTIME_base-utils} \
    busybox base-passwd \
    ${ROOTFS_BOOTSTRAP_INSTALL} \
"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "distro-image-initramfs"
IMAGE_NAME_SUFFIX ?= ""
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

inherit core-image user-key-store

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

INITRAMFS_MAXSIZE = "256000"

BAD_RECOMMENDATIONS += "busybox-syslog"

DEPENDS += "openssl-native"

# Do not perform sota operations

IMAGE_CLASSES:remove:sota = "image_repo_manifest"

IMAGE_FSTYPES:remove:sota = "ostreepush garagesign garagecheck ostree ostree.tar.gz ota ota.tar.gz ota-btrfs ota-ext4"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

fakeroot python do_sign:class-target() {
    import shutil

    deploy_dir = d.getVar('DEPLOYDIR')
    img_deploy_dir = d.getVar('IMGDEPLOYDIR')
    image_name = d.getVar('IMAGE_NAME')
    image_link_name = d.getVar('IMAGE_LINK_NAME')
    sb_file_ext = d.getVar('SB_FILE_EXT')

    if not os.path.exists(deploy_dir):
        os.mkdir(deploy_dir)

    for type in d.getVar('IMAGE_FSTYPES').split():
        type_ext = '.' + type

        image = os.path.join(img_deploy_dir, image_name + type_ext)
        image_ext = image + sb_file_ext
        uks_bl_sign(image, d)

        link_ext = os.path.join(img_deploy_dir, image_link_name + type_ext + sb_file_ext)
        if os.path.lexists(link_ext):
            os.remove(link_ext)
        os.symlink(os.path.basename(image + sb_file_ext), link_ext)
        shutil.move(image_ext, deploy_dir)
        shutil.move(link_ext, deploy_dir)
}

python do_sign() {
}

SSTATETASKS += "do_sign"

DEPLOYDIR = "${WORKDIR}/deploy-${PN}-sign"

addtask sign after do_image_complete before do_build
do_sign[prefuncs] += "check_deploy_keys"
do_sign[prefuncs] += "${@'check_boot_public_key' if d.getVar('GRUB_SIGN_VERIFY') == '1' else ''}"
do_sign[sstate-name] = "sign"
do_sign[sstate-inputdirs] = "${DEPLOYDIR}"
do_sign[sstate-outputdirs] = "${DEPLOY_DIR_IMAGE}"

python do_sign_setscene() {
    sstate_setscene(d)
}

addtask do_sign_setscene

do_sign[dirs] = "${DEPLOYDIR} ${DEPLOY_DIR_IMAGE}"
