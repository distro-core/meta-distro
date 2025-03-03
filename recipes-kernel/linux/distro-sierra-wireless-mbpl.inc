FILESEXTRAPATHS:prepend := "${THISDIR}/sierra-wireless-mbpl:"

# https://source.sierrawireless.com MBPL_DRIVERS_R35_ENG4-usb-src.tar

SRC_URI:append = " \
file://sierra-wireless-mbpl.cfg \
file://qcserial.c \
file://qmi_wwan.c \
file://usb_wwan.c \
file://usb-wwan.h \
"

do_configure:prepend () {
    cp -f ${WORKDIR}/qcserial.c ${S}/drivers/usb/serial/qcserial.c
    cp -f ${WORKDIR}/qmi_wwan.c ${S}/drivers/net/usb/qmi_wwan.c
    cp -f ${WORKDIR}/usb_wwan.c ${S}/drivers/usb/serial/usb_wwan.c
    cp -f ${WORKDIR}/usb-wwan.h ${S}/drivers/usb/serial/usb-wwan.h
}

# KERNEL_MODULE_AUTOLOAD += "qcserial qmi-wwan usb-wwan"
