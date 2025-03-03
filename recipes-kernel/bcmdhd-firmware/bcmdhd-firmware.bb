DESCRIPTION = "Broadcom wireless firmware bcmdhd"

LICENSE = "CLOSED"

SRC_URI = "git://github.com/CoreELEC/brcmfmac_sdio-firmware-aml.git;branch=master;protocol=https"

SRCREV = "cc05b0e463ce966d1ccf0230cffa50f7f4dd3376"

PV = "1.0+git${SRCPV}"

DEPENDS = "virtual/kernel"

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${libdir}/firmware/brcm
    cp -r ${S}/firmware/brcm/* ${D}${libdir}/firmware/brcm
}

FILES:${PN} += "${libdir}/"
