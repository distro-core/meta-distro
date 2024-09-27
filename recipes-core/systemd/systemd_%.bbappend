FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sudoers"

RESOLV_CONF = "stub-resolv"

PACKAGECONFIG = " \
${@bb.utils.contains('DISTRO_FEATURES', 'minidebuginfo', 'coredump elfutils', '', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', '', 'link-udev-shared', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'rfkill', '', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xkbcommon', '', d)} \
${@bb.utils.filter('DISTRO_FEATURES', 'acl audit efi ldconfig pam selinux smack usrmerge polkit seccomp', d)} \
backlight \
binfmt \
cgroupv2 \
gshadow \
hibernate \
hostnamed \
idn \
ima \
kmod \
localed \
logind \
machined \
myhostname \
networkd \
nss \
nss-mymachines \
nss-resolve \
quotacheck \
randomseed \
resolved \
set-time-epoch \
sysusers \
sysvinit \
timedated \
timesyncd \
userdb \
utmp \
vconsole \
wheel-group \
zstd \
cryptsetup \
cryptsetup-plugins \
no-dns-fallback \
no-ntp-fallback \
openssl \
tpm2 \
"

PACKAGECONFIG:remove = " \
myhostname \
serial-getty-generator \
"

RDEPENDS:${PN} += " \
${@bb.utils.contains('PACKAGECONFIG', 'logind', 'pam-plugin-umask', '', d)} \
e2fsprogs-e2fsck \
os-release \
systemd-conf \
systemd-extra-utils \
"
# kernel-module-autofs4 kernel-module-unix kernel-module-ipv6 kernel-module-sch-fq-codel

RDEPENDS:${PN}:remove = "systemd-serialgetty"

SYSTEMD_AUTO_ENABLE:${PN}-binfmt = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-journal-gatewayd = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-journal-upload = "disable"
SYSTEMD_AUTO_ENABLE:${PN}-journal-remote = "disable"

EXTRA_OEMESON += "-Ddefault-mdns=no"
EXTRA_OEMESON += "-Ddefault-llmnr=no"
EXTRA_OEMESON += "-Ddefault-user-shell='/bin/sh'"
EXTRA_OEMESON += "-Dsysupdate=true"
EXTRA_OEMESON += "-Ddefault-timeout-sec=90"
EXTRA_OEMESON += "-Ddefault-user-timeout-sec=90"

do_install:append() {
    # sudoers
    install -D -m 0640 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}
    # set default target
    # ln -sf ${SYSTEMD_DEFAULT_TARGET} ${D}${systemd_system_unitdir}/default.target
    ln -sf ${SYSTEMD_DEFAULT_TARGET} ${D}${sysconfdir}/systemd/system/default.target
    # mask services
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/run-media-ESP\\x2dsda1.mount
    ln -sf /dev/null ${D}${sysconfdir}/systemd/system/run-media-boot\\x2dsda2.mount
}

do_install:append:class-native() {
    rm -f ${D}${rootlibexecdir}/systemd/systemd-udevd ${D}${base_sbindir}/udevd
    rm -f ${D}${base_bindir}/udevadm ${D}${base_sbindir}udevadm
}

CONFFILES:${PN} = ""

FILES:${PN} += "${systemd_system_unitdir}/default.target ${sysconfdir}/systemd/system/default.target ${sysconfdir}/sudoers.d/"
FILES:${PN} += "${sysconfdir}/systemd/system/systemd-networkd-wait-online.service"
FILES:${PN} += "${sysconfdir}/systemd/system/run-media-ESP\\x2dsda1.mount"
FILES:${PN} += "${sysconfdir}/systemd/system/run-media-boot\\x2dsda2.mount"
