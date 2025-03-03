SUMMARY = "packagegroups"
DESCRIPTION = "DISTRO packagegroups"

# POLICY: The packagegroup only reference open source recipes; #there should
# be no company intellectual property associated to these packagegroups, either
# directly or indirectly. RDEPENDS to leaf recipes are allowed, but should be
# migrated to the recipe directly by .bbappends and removed from the packagegroups
# for #proper dependency management.

# Packagegroups are logically partitioned into external and internal use. The
# external packagegroups serve as a meta and are exposed for use by images.
# The internal packagegroups serve as a method to partition functionality or
# features that are then incorporated into the exposed external meta.

# MACHINE packages ARE NOT captured within this packagegroup.

# Examples include images with core functionality and applications captured
# as a named meta packagegroup. The combinations are exposed as

# Packagegroup          Description
# ${PN}-core            Core functionality
# ${PN}-core-sdk        Core functionality with SDK
# ${PN}-full            Full functionality with GUI

# When creating or editing the package groups, generally a new group would
# be internal, and then added to an external meta group. When a specific use
# case is identified for external images, use an existing meta packagegroup
# as the template. Aspects of build-in inclusion are denoted with the use
# of an OVERRIDE from DISTROOVERRIDES or MACHINEOVERRIDES. Where functionality
# is only available from a specific Yocto meta-* layer, incorporate the \
# appropriate conditional checks and test with that layer absent.

# OVERRIDES                 Description
# none                      default required even if empty
# :distro-guest             additions for virtual machine guests
# :distro-gui               additions for gnome, xfce, wayland, x11
# :distro-kubernetes        additions for kubernetes, k3s
# :distro-kvm               additions for kvm, lxc, libvirt
# :distro-testfw            additions for test frameworks
# :libc-glibc               additions for runtime glibc, locales
# :libc-musl                additions for runtime musl
# :<distrooverride>         additions for DISTROOVERRIDES
# :<machineoverride>        additions for MACHINEOVERRIDES

# Pattern used to include dependency supplied by distro feature
# ${@bb.utils.contains('DISTRO_FEATURES', 'feature', 'feature-dependencies', '', d)}

# The packages for this package group are expected to be specialized based on TUNE_PKGARCH
PACKAGE_ARCH = "${TUNE_PKGARCH}"

# packagegroups to organize within this ${PN}
INTERNAL_PG = "${PN}"

EXCLUDE_FROM_WORLD = "1"

inherit packagegroup

FILES:${PN} = ""
RDEPENDS:${PN} = ""

####################

PACKAGES += "${PN}-core"
SUMMARY:${PN}-core = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-core = ""
FILES:${PN}-core = ""
RDEPENDS:${PN}-core = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'cloud-init', '', d)} \
${INTERNAL_PG}-docker \
${INTERNAL_PG}-logging \
${INTERNAL_PG}-luks \
${INTERNAL_PG}-lvm2 \
${INTERNAL_PG}-network \
${INTERNAL_PG}-ostree \
${INTERNAL_PG}-test-framework \
${INTERNAL_PG}-udev \
${PN}-systemd \
${PN}-tpm \
${PN}-tpm2 \
acpid \
attr \
bash \
busybox \
bzip2 \
cpufrequtils \
curl \
dash \
dbus \
dmidecode \
git \
gnupg \
jq \
kbd \
kbd-consolefonts \
kbd-keymaps \
kbd-unimaps \
libpam \
libpam-runtime \
libpcre2 \
libseccomp \
lzo \
ncurses \
nvme-cli \
os-release \
pam-plugin-access \
pigz \
procps \
python3-core \
setserial \
setserial \
shadow-base \
shadow-securetty \
sqlite3 \
terminus-font-consolefonts \
tmux \
usb-modeswitch \
usbutils \
util-linux-agetty \
util-linux-fsck \
util-linux-mount \
util-linux-nsenter \
util-linux-umount \
zlib \
zstd \
"
# include in image-name.bb
RRECOMMENDS:${PN}-core = "${PN}-machine"

####################

PACKAGES += "${PN}-core-sdk"
SUMMARY:${PN}-core-sdk = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-core-sdk = ""
FILES:${PN}-core-sdk = ""
RDEPENDS:${PN}-core-sdk = " \
packagegroup-core-sdk \
packagegroup-core-standalone-sdk-target \
repo \
"

####################

PACKAGES += "${PN}-full"
SUMMARY:${PN}-full = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-full = ""
FILES:${PN}-full = ""
RDEPENDS:${PN}-full = " \
${INTERNAL_PG}-extras \
${INTERNAL_PG}-network-extras \
"
RDEPENDS:${PN}-full:append:distro-gui = "${PN}-gui-gnome ${PN}-gui-xfce"

####################

PACKAGES += "${INTERNAL_PG}-gui-core"
SUMMARY:${INTERNAL_PG}-gui-core = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-gui-core = ""
FILES:${INTERNAL_PG}-gui-core = ""
RDEPENDS:${INTERNAL_PG}-gui-core = ""
RDEPENDS:${INTERNAL_PG}-gui-core:distro-gui = " \
${VIRTUAL-RUNTIME_graphical_init_manager} \
packagegroup-core-x11 \
terminus-font-pcf \
wayland-utils \
weston \
weston-examples \
weston-init \
"

####################

PACKAGES += "${PN}-gui-gnome"
SUMMARY:${PN}-gui-gnome = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-gui-gnome = ""
FILES:${PN}-gui-gnome = ""
RDEPENDS:${PN}-gui-gnome = ""
RDEPENDS:${PN}-gui-gnome:distro-gui = " \
${INTERNAL_PG}-gui-core \
${@bb.utils.contains('TCLIBC', 'glibc', 'packagegroup-gnome-apps packagegroup-gnome-desktop', '', d)} \
"

####################

PACKAGES += "${PN}-gui-xfce"
SUMMARY:${PN}-gui-xfce = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-gui-xfce = ""
FILES:${PN}-gui-xfce = ""
RDEPENDS:${PN}-gui-xfce = ""
RDEPENDS:${PN}-gui-xfce:distro-gui = " \
${INTERNAL_PG}-gui-core \
${@bb.utils.contains('TCLIBC', 'glibc', 'packagegroup-xfce-base packagegroup-xfce-extended packagegroup-xfce-multimedia', '', d)} \
${@bb.utils.contains('TCLIBC', 'musl', 'packagegroup-xfce-base packagegroup-xfce-extended packagegroup-xfce-multimedia', '', d)} \
"

####################

PACKAGES += "${PN}-mdev-busybox"
SUMMARY:${PN}-mdev-busybox = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-mdev-busybox = ""
FILES:${PN}-mdev-busybox = ""
RDEPENDS:${PN}-mdev-busybox = ""

####################

PACKAGES += "${PN}-systemd"
SUMMARY:${PN}-systemd = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-systemd = ""
FILES:${PN}-systemd = ""
RDEPENDS:${PN}-systemd = " \
${INTERNAL_PG}-udev \
${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd systemd-analyze systemd-conf systemd-container systemd-extra-utils systemd-kernel-install systemd-udev-rules', '', d)} \
"

####################

PACKAGES += "${PN}-sysvinit"
SUMMARY:${PN}-sysvinit = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-sysvinit = ""
FILES:${PN}-sysvinit = ""
RDEPENDS:${PN}-sysvinit = " \
${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'sysvinit sysvinit-inittab', '', d)} \
"

####################

# TPM 1.2, requires meta-security/meta-tpm
# Generates empty package when layer is not present

TPM1_COMMON = " \
openssl-tpm-engine \
pcr-extend \
tpm-tools \
trousers \
"

PACKAGES += "${PN}-tpm"
SUMMARY:${PN}-tpm = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-tpm = ""
FILES:${PN}-tpm = ""
RDEPENDS:${PN}-tpm = " \
${@bb.utils.contains('DISTRO_FEATURES', 'tpm', '${TPM1_COMMON}', '', d)} \
"

####################

# TPM 2.0, requires meta-secure-core/meta-tpm2 OR meta-security/meta-tpm
# Generates empty package when layer is not present

TPM2_COMMON = " \
libtss2 \
libtss2-mu \
libtss2-tcti-device \
libtss2-tcti-mssim \
tpm2-abrmd \
tpm2-tools \
tpm2-tss \
tpm2-tss-engine \
"
# tpm2-pkcs11

PACKAGES += "${PN}-tpm2"
SUMMARY:${PN}-tpm2 = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${PN}-tpm2 = ""
FILES:${PN}-tpm2 = ""
RDEPENDS:${PN}-tpm2 = " \
${@bb.utils.contains('DISTRO_FEATURES', 'tpm2', '${TPM2_COMMON}', '', d)} \
"

############################################################

PACKAGES += "${INTERNAL_PG}-extras"
SUMMARY:${INTERNAL_PG}-extras = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-extras = ""
FILES:${INTERNAL_PG}-extras = ""
RDEPENDS:${INTERNAL_PG}-extras = " \
iftop \
util-linux-fdisk \
tzdata \
parted \
"
# lmsensors lmsensors-config

####################

PACKAGES += "${INTERNAL_PG}-docker"
SUMMARY:${INTERNAL_PG}-docker = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-docker = ""
FILES:${INTERNAL_PG}-docker = ""
RDEPENDS:${INTERNAL_PG}-docker = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', ' \
    ${PREFERRED_PROVIDER_virtual/docker} \
    ${PREFERRED_PROVIDER_virtual/docker}-contrib \
    ${PREFERRED_PROVIDER_virtual/containerd} \
    ${PREFERRED_PROVIDER_virtual/runc} \
    slirp4netns \
    nm-docker-network \
    cloud-init \
    ', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-k3s"
SUMMARY:${INTERNAL_PG}-k3s = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-k3s = ""
FILES:${INTERNAL_PG}-k3s = ""
RDEPENDS:${INTERNAL_PG}-k3s = ""
RDEPENDS:${INTERNAL_PG}-k3s:distro-kubernetes = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'k3s-agent k3s-server', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-kubernetes"
SUMMARY:${INTERNAL_PG}-kubernetes = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-kubernetes = ""
FILES:${INTERNAL_PG}-kubernetes = ""
RDEPENDS:${INTERNAL_PG}-kubernetes = ""
RDEPENDS:${INTERNAL_PG}-kubernetes:distro-kubernetes = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'kubernetes', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-lxc"
SUMMARY:${INTERNAL_PG}-lxc = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-lxc = ""
FILES:${INTERNAL_PG}-lxc = ""
RDEPENDS:${INTERNAL_PG}-lxc = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'lxc lxc-networking lxc-templates lxcfs', '', d)} \
"
# unavailable libc-musl
RDEPENDS:${INTERNAL_PG}-lxc:libc-musl = ""

####################

# PACKAGES += "${INTERNAL_PG}-kvm-qemu"
SUMMARY:${INTERNAL_PG}-kvm-qemu = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-kvm-qemu = ""
FILES:${INTERNAL_PG}-kvm-qemu = ""
RDEPENDS:${INTERNAL_PG}-kvm-qemu = ""
RDEPENDS:${INTERNAL_PG}-kvm-qemu:distro-kvm = " \
dtc \
gnutls \
libaio \
libcap-ng \
libgcrypt \
libssh \
liburing \
libusb1 \
libxml2 \
ncurses \
qemu \
usbredir \
yajl \
"
# libvirt req gobject-introspection

####################

PACKAGES += "${INTERNAL_PG}-podman"
SUMMARY:${INTERNAL_PG}-podman = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-podman = ""
FILES:${INTERNAL_PG}-podman = ""
RDEPENDS:${INTERNAL_PG}-podman = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', ' \
    podman \
    virtual-runc \
    slirp4netns \
    nm-docker-network \
    cloud-init \
    ', '', d)} \
"

####################

PACKAGES += "${INTERNAL_PG}-logging"
SUMMARY:${INTERNAL_PG}-logging = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-logging = ""
FILES:${INTERNAL_PG}-logging = ""
RDEPENDS:${INTERNAL_PG}-logging = " \
audit \
auditd \
logrotate \
mosquitto \
mosquitto-clients \
syslog-ng \
"
# audispd-plugins

####################

PACKAGES += "${INTERNAL_PG}-logging-libs"
SUMMARY:${INTERNAL_PG}-logging-libs = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-logging-libs = ""
FILES:${INTERNAL_PG}-logging-libs = ""
RDEPENDS:${INTERNAL_PG}-logging-libs = " \
rabbitmq-c \
paho-mqtt-c \
paho-mqtt-cpp \
python3-paho-mqtt \
"

####################

PACKAGES += "${INTERNAL_PG}-luks"
SUMMARY:${INTERNAL_PG}-luks = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-luks = ""
FILES:${INTERNAL_PG}-luks = ""
RDEPENDS:${INTERNAL_PG}-luks = " \
cryptsetup \
libdevmapper \
"

####################

PACKAGES += "${INTERNAL_PG}-lvm2"
SUMMARY:${INTERNAL_PG}-lvm2 = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-lvm2 = ""
FILES:${INTERNAL_PG}-lvm2 = ""
RDEPENDS:${INTERNAL_PG}-lvm2 = " \
${INTERNAL_PG}-udev \
lvm2 \
lvm2-udevrules \
libdevmapper \
"

####################

# PACKAGES += "${INTERNAL_PG}-connman"
SUMMARY:${INTERNAL_PG}-connman = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-connman = ""
FILES:${INTERNAL_PG}-connman = ""
RDEPENDS:${INTERNAL_PG}-connman = " \
connman \
ofono \
"
RDEPENDS:${INTERNAL_PG}-connman:distro-gui += "connman-gnome"

####################

PACKAGES += "${INTERNAL_PG}-networkmanager"
SUMMARY:${INTERNAL_PG}-networkmanager = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-networkmanager = ""
FILES:${INTERNAL_PG}-networkmanager = ""
RDEPENDS:${INTERNAL_PG}-networkmanager = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'python3-networkmanager', '', d)} \
modemmanager \
networkmanager \
networkmanager-nmcli \
netplan \
"

####################

# Mutually exclusive ${INTERNAL_PG}-connman OR ${INTERNAL_PG}-networkmanager

PACKAGES += "${INTERNAL_PG}-network-core"
SUMMARY:${INTERNAL_PG}-network-core = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-network-core = ""
FILES:${INTERNAL_PG}-network-core = ""
RDEPENDS:${INTERNAL_PG}-network-core = " \
${INTERNAL_PG}-networkmanager \
packagegroup-core-ssh-openssh \
ethtool \
gpsd \
iproute2 \
iptables \
libmbim \
libqmi \
nftables \
openssl \
ifupdown \
iputils \
"
RCONFLICTS:${INTERNAL_PG}-network-core = "packagegroup-core-ssh-dropbear"

####################

PACKAGES += "${INTERNAL_PG}-network"
SUMMARY:${INTERNAL_PG}-network = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-network = ""
FILES:${INTERNAL_PG}-network = ""
RDEPENDS:${INTERNAL_PG}-network = " \
${INTERNAL_PG}-network-core \
dnsmasq \
hostapd \
libnetfilter-log \
wireless-regdb-static \
wpa-supplicant \
"
# cloud-utils

####################

PACKAGES += "${INTERNAL_PG}-network-extras"
SUMMARY:${INTERNAL_PG}-network-extras = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-network-extras = ""
FILES:${INTERNAL_PG}-network-extras = ""
RDEPENDS:${INTERNAL_PG}-network-extras = " \
${INTERNAL_PG}-network \
conntrack-tools \
htop \
iperf2 \
iperf3 \
pimd \
tailscale \
tcpdump \
tunctl \
vlan \
wireguard-tools \
wireshark \
"

####################

PACKAGES += "${INTERNAL_PG}-ostree"
SUMMARY:${INTERNAL_PG}-ostree = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-ostree = ""
FILES:${INTERNAL_PG}-ostree = ""
RDEPENDS:${INTERNAL_PG}-ostree = " \
ostree \
"

####################

PACKAGES += "${INTERNAL_PG}-test-framework"
SUMMARY:${INTERNAL_PG}-test-framework = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-test-framework = ""
FILES:${INTERNAL_PG}-test-framework = ""
RDEPENDS:${INTERNAL_PG}-test-framework:distro-testfw = " \
python3-robotframework \
python3-robotframework-seriallibrary \
"

####################

PACKAGES += "${INTERNAL_PG}-udev"
SUMMARY:${INTERNAL_PG}-udev = "Packagegroup for ${PACKAGE_ARCH}"
DESCRIPTION:${INTERNAL_PG}-udev = ""
FILES:${INTERNAL_PG}-udev = ""
RDEPENDS:${INTERNAL_PG}-udev = " \
udev \
udev-extraconf \
"
