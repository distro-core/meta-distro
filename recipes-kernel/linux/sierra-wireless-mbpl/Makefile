#
# Makefile for the qcserial
#

# core layer
obj-m := qcserial.o usb_wwan.o qmi_wwan.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)

debug:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) ccflags-y="-DDEBUG"

clean:
	rm -rf *.o *.cmd *.ko *.mod.c .tmp_versions *.o.ur-safe *.symvers *.order .cache.mk .mhi* .built-in* built-in.a *.mod

install:
	if [ -f /lib/modules/`uname -r`/kernel/drivers/usb/serial/qcserial.ko.zst ]; then \
	zstd -f qcserial.ko; sudo cp qcserial.ko.zst /lib/modules/`uname -r`/kernel/drivers/usb/serial/qcserial.ko.zst; \
	zstd -f usb_wwan.ko; sudo cp usb_wwan.ko.zst /lib/modules/`uname -r`/kernel/drivers/usb/serial/usb_wwan.ko.zst; \
	zstd -f qmi_wwan.ko; sudo cp qmi_wwan.ko.zst /lib/modules/`uname -r`/kernel/drivers/net/usb/qmi_wwan.ko.zst; \
	else \
	sudo cp qcserial.ko /lib/modules/`uname -r`/kernel/drivers/usb/serial/qcserial.ko; \
	sudo cp usb_wwan.ko /lib/modules/`uname -r`/kernel/drivers/usb/serial/usb_wwan.ko; \
	sudo cp qmi_wwan.ko /lib/modules/`uname -r`/kernel/drivers/net/usb/qmi_wwan.ko; \
	fi 
	
	sudo depmod
	

