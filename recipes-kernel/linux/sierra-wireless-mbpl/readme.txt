Sierra Wireless USB Drivers
===========================
Supported Product Families (based on chipset): SDX65, SDX55, 9x50, 9x30, 9x15, 9x07 

How to Build the driver
=======================
run "make" to generate the driver binaries: qcserial.ko, usb_wwan.ko and qmi_wwan.ko

How to Install the driver
========================= 
1. run "make install"
2. reboot

Note: Linux kernel may not load driver if secure boot is enabled in BIOS. 
Secure boot need to be disabled in BIOS and reboot.

How to verify driver installation
=================================
"lsusb -t" should generate an output as below 
(Example for an SDX55 USB modem - MBIM mode): 

/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/8p, 5000M
    |__ Port 2: Dev 4, If 0, Class=Mass Storage, Driver=usb-storage, 5000M
    |__ Port 7: Dev 2, If 5, Class=Vendor Specific Class, Driver=, 5000M
    |__ Port 7: Dev 2, If 3, Class=Vendor Specific Class, Driver=qcserial, 5000M
    |__ Port 7: Dev 2, If 1, Class=CDC Data, Driver=cdc_mbim, 5000M
    |__ Port 7: Dev 2, If 4, Class=Vendor Specific Class, Driver=qcserial, 5000M
    |__ Port 7: Dev 2, If 0, Class=Communications, Driver=cdc_mbim, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/16p, 480M
    |__ Port 9: Dev 2, If 0, Class=Human Interface Device, Driver=usbhid, 1.5M
    |__ Port 9: Dev 2, If 1, Class=Human Interface Device, Driver=usbhid, 1.5M
    |__ Port 10: Dev 3, If 0, Class=Human Interface Device, Driver=usbhid, 1.5M

The driver exposes two device interfaces 
(Example for an SDX55 modem - MBIM mode)
1. /dev/ttyUSB0, AT port
2. /dev/ttyUSB1, DM port

"lsusb -t" should generate an output as below 
(Example for a 9x50 USB modem - RmNet mode): 

/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/10p, 10000M
    |__ Port 4: Dev 4, If 0, Class=Vendor Specific Class, Driver=qcserial, 5000M
    |__ Port 4: Dev 4, If 2, Class=Vendor Specific Class, Driver=qcserial, 5000M
    |__ Port 4: Dev 4, If 3, Class=Vendor Specific Class, Driver=qcserial, 5000M
    |__ Port 4: Dev 4, If 8, Class=Vendor Specific Class, Driver=qmi_wwan, 5000M

The driver exposes three device interfaces 
(Example for a 9x50 USB modem - RmNet mode):
1. /dev/ttyUSB0, DM port
2. /dev/ttyUSB1, NMEA port
3. /dev/ttyUSB2, AT port

How to communicate with AT port 
==================================
run "sudo minicom -D /dev/ttyUSB0". 
(ttyUSB0 is the AT port in this example, it may vary).

To close it, press CTRL+A and then X

Enable zero length packet in usb_wwan
=====================================
To support FW download on 9x50 based products, driver must support USB
zero length packets (ZLP). This feature is not enabled in the open source usb_wwan driver
(for some kernel version). 
The attached usb_wwan.c shows how to enable ZLP.

In usb_wwan_setup_urb function, the following two lines of code:

	if (intfdata->use_zlp && dir == USB_DIR_OUT)
		urb->transfer_flags |= URB_ZERO_PACKET;

This indicates the ZLP feature is enabled.

NMEA port streaming
==================================
To enable the NMEA streaming on the NMEA port, the following 
command must be issued before opening the port. 

echo "\$GPS_START" > /dev/ttyUSB1   
(ttyUSB1 is the NMEA port in this example, it may vary).

How to enable driver logging
=======================================
1. run "make debug".
2. reinstall driver.
3. enable dynamic debug. 
sudo echo file qcserial.c +p > /sys/kernel/debug/dynamic_debug/control
sudo echo file usb_wwan.c +p > /sys/kernel/debug/dynamic_debug/control
sudo echo file qmi_wwan.c +p > /sys/kernel/debug/dynamic_debug/control
4. run dmesg, and then power cycle device. driver log should be shown in dmesg output. 

For more information about dynamic debug, please check https://lwn.net/Articles/434856/

How to enable driver logging at runtime
=======================================
Navigate to the directory /sys/module/qcserial/parameters, run "sudo chmod 666 debug" and then "echo 1 > debug". 

Change qcserial to usb_wwan or qmi_wwan in the above directory to enable logging for usb_wwan or qmi_wwan.

