FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "rEFInd boot manager"
DESCRIPTION = "rEFInd is a fork of the rEFIt boot manager. Like rEFIt, rEFInd can auto-detect \
your installed EFI boot loaders and it presents a pretty GUI menu of boot options. rEFInd goes \
beyond rEFIt in that rEFInd better handles systems with many boot loaders, gives better control \
over the boot loader search process, and provides the ability for users to define their own \
boot loader entries."

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://git.code.sf.net/p/refind/code;branch=master;protocol=https"

SRCREV = "8aca5d112d4a79cb4a7719bb51d8889f0ba6a803"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

S = "${WORKDIR}/git"

DEPENDS = "gnu-efi"

COMPATIBLE_HOST = "(x86_64.*|i.86.*|aarch64.*|arm.*)-linux"

TOOLCHAIN = "gcc"

inherit autotools

# meta-intel
# inherit ${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'uefi-sign', '', d)}
# meta-secure-core/meta-signing-key
inherit user-key-store

# # These should be configured as needed
SBAT_DISTRO_ID ?= "${DISTRO}"
SBAT_DISTRO_SUMMARY ?= "${DISTRO_NAME}"
SBAT_DISTRO_URL ?= ""

EXTRA_OEMESON += "-Defi-cc="${@meson_array('CC', d)}" \
                  -Defi-ld='${HOST_PREFIX}ld' \
                  -Defi-includedir=${STAGING_INCDIR}/efi \
                  -Defi-libdir=${STAGING_LIBDIR} \
                  -Defi_sbat_distro_id='${SBAT_DISTRO_ID}' \
                  -Defi_sbat_distro_summary='${SBAT_DISTRO_SUMMARY}' \
                  -Defi_sbat_distro_url='${SBAT_DISTRO_URL}' \
                  -Defi_sbat_distro_pkgname='${PN}' \
                  -Defi_sbat_distro_version='${PV}'\
                  "
