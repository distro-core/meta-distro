DESCRIPTION = "Broadcom wireless driver bcmdhd"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/StreamUnlimited/broadcom-bcmdhd-4359.git;branch=master;protocol=https"

SRCREV = "15c05dfb48083097861e0d3465001f9267e2c99d"

PV = "1.0+git${SRCPV}"

DEPENDS = "virtual/kernel"

S = "${WORKDIR}/git"

inherit module

KERNEL_MODULE_AUTOLOAD += "bcmdhd"

RPROVIDES:${PN} += "kernel-module-bcmdhd"

RDEPENDS:${PN} += "bcmdhd-firmware"
