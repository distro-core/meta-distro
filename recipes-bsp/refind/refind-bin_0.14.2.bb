FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "rEFInd boot manager binaries"
DESCRIPTION = "rEFInd selected binaries for use as efi drivers"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "https://sourceforge.net/projects/refind/files/${PV}/refind-bin-${PV}.zip"

SRC_URI[sha256sum] = "410c7828c4fec2f2179bd956073522415831d27c00416381b8f71153c190a311"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

require conf/image-uefi.conf

# meta-intel
# inherit ${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'uefi-sign', '', d)}
# meta-secure-core/meta-signing-key
inherit user-key-store

do_install() {
    if [ -z "${EFI_ARCH}" ]; then
        bbfatal "EFI_ARCH is not defined"
    fi
    install -D -m 0644 ${S}/refind/drivers_${EFI_ARCH}/ext2_${EFI_ARCH}.efi ${D}${EFI_PREFIX}/EFI/systemd/drivers/ext2_${EFI_ARCH}.efi
    install -D -m 0644 ${S}/refind/drivers_${EFI_ARCH}/ext4_${EFI_ARCH}.efi ${D}${EFI_PREFIX}/EFI/systemd/drivers/ext4_${EFI_ARCH}.efi
    install -D -m 0644 ${S}/refind/drivers_${EFI_ARCH}/btrfs_${EFI_ARCH}.efi ${D}${EFI_PREFIX}/EFI/systemd/drivers/btrfs_${EFI_ARCH}.efi
    # hfs_${EFI_ARCH}.efi iso9660_${EFI_ARCH}.efi reiserfs_${EFI_ARCH}.efi
}

FILES:${PN} = " \
${EFI_PREFIX}/EFI/systemd/drivers/ext2_${EFI_ARCH}.efi \
${EFI_PREFIX}/EFI/systemd/drivers/ext4_${EFI_ARCH}.efi \
${EFI_PREFIX}/EFI/systemd/drivers/btrfs_${EFI_ARCH}.efi \
"

inherit deploy
do_deploy() {
    install -D ${S}/refind/drivers_${EFI_ARCH}/ext2_${EFI_ARCH}.efi ${DEPLOYDIR}/ext2_${EFI_ARCH}.efi
    install -D ${S}/refind/drivers_${EFI_ARCH}/ext4_${EFI_ARCH}.efi ${DEPLOYDIR}/ext4_${EFI_ARCH}.efi
    install -D ${S}/refind/drivers_${EFI_ARCH}/btrfs_${EFI_ARCH}.efi ${DEPLOYDIR}/btrfs_${EFI_ARCH}.efi
}
addtask deploy after do_install before do_package
