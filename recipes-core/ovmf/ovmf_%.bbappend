# serialize building (avoid OOM with limited resources)
# do_compile[depends] += "virtual/kernel:do_populate_sysroot"
BB_NUMBER_THREADS = "${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"
# PARALLEL_MAKE = "-j ${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"

PACKAGECONFIG += "${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'secureboot', '', d)}"

require conf/image-uefi.conf

# meta-intel
# inherit ${@bb.utils.contains('IMAGE_FEATURES', 'secureboot', 'uefi-sign', '', d)}
# meta-secure-core/meta-signing-key
# inherit user-key-store

# replace do_install
do_install:class-target() {

cat >${WORKDIR}/startup.nsh <<_EOF_
fs0:\\EFI\\BOOT\\boot${EFI_ARCH}.efi
_EOF_

cat >${WORKDIR}/shell${EFI_ARCH}.conf <<_EOF_
title EFI Shell
sort-key 99
options -nostartup
efi shell${EFI_ARCH}.efi
_EOF_

install -D -m 0755 ${WORKDIR}/ovmf/Shell.efi ${D}${EFI_PREFIX}/shell${EFI_ARCH}.efi
install -D -m 0644 ${WORKDIR}/startup.nsh ${D}${EFI_PREFIX}/startup.nsh
install -D -m 0644 ${WORKDIR}/shell${EFI_ARCH}.conf ${D}${EFI_PREFIX}/loader/entries/shell${EFI_ARCH}.conf

}

FILES:ovmf-shell-efi = " \
/EnrollDefaultKeys.efi \
${EFI_PREFIX}/shell${EFI_ARCH}.efi ${EFI_PREFIX}/startup.nsh ${EFI_PREFIX}/loader/entries/shell${EFI_ARCH}.conf \
"

inherit deploy
do_deploy:class-target() {
    install -D ${D}${EFI_PREFIX}/shell${EFI_ARCH}.efi ${DEPLOYDIR}/shell${EFI_ARCH}.efi
    install -D ${D}${EFI_PREFIX}/startup.nsh ${DEPLOYDIR}/startup.nsh
    install -D ${D}${EFI_PREFIX}/loader/entries/shell${EFI_ARCH}.conf ${DEPLOYDIR}/shell${EFI_ARCH}.conf
}
addtask deploy after do_install before do_package
