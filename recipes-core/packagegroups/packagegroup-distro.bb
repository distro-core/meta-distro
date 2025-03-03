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

# Pattern used to include dependency supplied by layer-key
# ${@bb.utils.contains('BBFILE_COLLECTIONS', 'layer-key', 'layer-dependencies', '', d)}

# Pattern used to include dependency supplied by distro feature
# ${@bb.utils.contains('DISTRO_FEATURES', 'feature', 'feature-dependencies', '', d)}

# The packages for this package group are expected to be specialized based on TUNE_PKGARCH
PACKAGE_ARCH = "${TUNE_PKGARCH}"

# packagegroups to organize within this ${PN}
INTERNAL_PG = "${PN}-internal"

EXCLUDE_FROM_WORLD = "1"

inherit packagegroup

FILES:${PN} = ""
RDEPENDS:${PN} = ""

####################

PACKAGES += "${PN}-core"
SUMMARY:${PN}-core = "Packagegroup for images"
DESCRIPTION:${PN}-core = "Description"
FILES:${PN}-core = ""
RDEPENDS:${PN}-core = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'terminus-font-consolefonts', '', d)} \
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
procps \
python3-core \
setserial \
setserial \
shadow-base \
shadow-securetty \
sqlite3 \
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
SUMMARY:${PN}-core-sdk = "Packagegroup for images"
DESCRIPTION:${PN}-core-sdk = "Description"
FILES:${PN}-core-sdk = ""
RDEPENDS:${PN}-core-sdk = " \
packagegroup-core-sdk \
packagegroup-core-standalone-sdk-target \
"

####################

PACKAGES += "${PN}-full"
SUMMARY:${PN}-full = "Packagegroup for images"
DESCRIPTION:${PN}-full = "Description"
FILES:${PN}-full = ""
RDEPENDS:${PN}-full = " \
${INTERNAL_PG}-extras \
${INTERNAL_PG}-network-extras \
"
RDEPENDS:${PN}-full:append:distro-gui = "${PN}-gui-gnome ${PN}-gui-xfce"

####################

PACKAGES += "${INTERNAL_PG}-gui-core"
SUMMARY:${PN}-gui-core = "Packagegroup for internal organization"
DESCRIPTION:${PN}-gui-core = "Packagegroup for internal organizaton"
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
SUMMARY:${PN}-gui-gnome = "Packagegroup for images"
DESCRIPTION:${PN}-gui-gnome = "Description"
FILES:${PN}-gui-gnome = ""
RDEPENDS:${PN}-gui-gnome = ""
RDEPENDS:${PN}-gui-gnome:distro-gui = " \
${INTERNAL_PG}-gui-core \
${@bb.utils.contains('TCLIBC', 'glibc', 'packagegroup-gnome-apps packagegroup-gnome-desktop', '', d)} \
"

####################

PACKAGES += "${PN}-gui-xfce"
SUMMARY:${PN}-gui-xfce = "Packagegroup for images"
DESCRIPTION:${PN}-gui-xfce = "Description"
FILES:${PN}-gui-xfce = ""
RDEPENDS:${PN}-gui-xfce = ""
RDEPENDS:${PN}-gui-xfce:distro-gui = " \
${INTERNAL_PG}-gui-core \
${@bb.utils.contains('TCLIBC', 'glibc', 'packagegroup-xfce-base packagegroup-xfce-extended packagegroup-xfce-multimedia', '', d)} \
${@bb.utils.contains('TCLIBC', 'musl', 'packagegroup-xfce-base packagegroup-xfce-extended packagegroup-xfce-multimedia', '', d)} \
"

####################

PACKAGES += "${PN}-mdev-busybox"
SUMMARY:${PN}-mdev-busybox = "Packagegroup for images"
DESCRIPTION:${PN}-mdev-busybox = "Description"
FILES:${PN}-mdev-busybox = ""
RDEPENDS:${PN}-mdev-busybox = ""

####################

PACKAGES += "${PN}-systemd"
SUMMARY:${PN}-systemd = "Packagegroup for images"
DESCRIPTION:${PN}-systemd = "Description"
FILES:${PN}-systemd = ""
RDEPENDS:${PN}-systemd = " \
${INTERNAL_PG}-udev \
${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd systemd-analyze systemd-conf systemd-container systemd-extra-utils systemd-kernel-install systemd-udev-rules', '', d)} \
"

####################

PACKAGES += "${PN}-sysvinit"
SUMMARY:${PN}-sysvinit = "Packagegroup for images"
DESCRIPTION:${PN}-sysvinit = "Description"
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
SUMMARY:${PN}-tpm = "Packagegroup for images"
DESCRIPTION:${PN}-tpm = "Description"
FILES:${PN}-tpm = ""
RDEPENDS:${PN}-tpm = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'tpm-layer', bb.utils.contains('DISTRO_FEATURES', 'tpm', '${TPM1_COMMON}', '', d), '', d)} \
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
"
# scarthgap: tpm2-openssl tpm2-pkcs11 tpm2-tss-engine

PACKAGES += "${PN}-tpm2"
SUMMARY:${PN}-tpm2= "Packagegroup for images"
DESCRIPTION:${PN}-tpm2 = "Description"
FILES:${PN}-tpm2 = ""
RDEPENDS:${PN}-tpm2 = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'tpm-layer', bb.utils.contains('DISTRO_FEATURES', 'tpm2', '${TPM2_COMMON}', '', d), '', d)} \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'tpm2', bb.utils.contains('DISTRO_FEATURES', 'tpm2', '${TPM2_COMMON}', '', d), '', d)} \
"
# tpm2-tss-engine-engines

############################################################

PACKAGES += "${INTERNAL_PG}-extras"
SUMMARY:${PN}-extras = "Packagegroup for internal organization"
DESCRIPTION:${PN}-extras = "Packagegroup for internal organizaton"
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
SUMMARY:${PN}-docker = "Packagegroup for internal organization"
DESCRIPTION:${PN}-docker = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-docker = ""
RDEPENDS:${INTERNAL_PG}-docker = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', ' \
    ${PREFERRED_PROVIDER_virtual/docker} \
    ${PREFERRED_PROVIDER_virtual/docker}-contrib \
    ${PREFERRED_PROVIDER_virtual/containerd} \
    ${PREFERRED_PROVIDER_virtual/runc}  \
    slirp4netns \
    nm-docker-network \
    ', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-k3s"
SUMMARY:${PN}-k3s = "Packagegroup for internal organization"
DESCRIPTION:${PN}-k3s = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-k3s = ""
RDEPENDS:${INTERNAL_PG}-k3s = ""
RDEPENDS:${INTERNAL_PG}-k3s:distro-kubernetes = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'k3s-agent k3s-server', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-kubernetes"
SUMMARY:${PN}-kubernetes = "Packagegroup for internal organization"
DESCRIPTION:${PN}-kubernetes = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-kubernetes = ""
RDEPENDS:${INTERNAL_PG}-kubernetes = ""
RDEPENDS:${INTERNAL_PG}-kubernetes:distro-kubernetes = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'kubernetes', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-lxc"
SUMMARY:${PN}-lxc = "Packagegroup for internal organization"
DESCRIPTION:${PN}-lxc = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-lxc = ""
RDEPENDS:${INTERNAL_PG}-lxc = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'lxc lxc-networking lxc-templates lxcfs', '', d)} \
"
# unavailable libc-musl
RDEPENDS:${INTERNAL_PG}-lxc:libc-musl = ""

####################

# PACKAGES += "${INTERNAL_PG}-kvm-qemu"
SUMMARY:${PN}-kvm-qemu = "Packagegroup for internal organization"
DESCRIPTION:${PN}-kvm-qemu = "Packagegroup for internal organizaton"
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
SUMMARY:${PN}-podman = "Packagegroup for internal organization"
DESCRIPTION:${PN}-podman = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-podman = ""
RDEPENDS:${INTERNAL_PG}-podman = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', ' \
    podman \
    virtual-runc \
    slirp4netns \
    nm-docker-network \
    ', '', d)} \
"

####################

PACKAGES += "${INTERNAL_PG}-logging"
SUMMARY:${PN}-logging = "Packagegroup for internal organization"
DESCRIPTION:${PN}-logging = "Packagegroup for internal organizaton"
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
SUMMARY:${PN}-logging-libs = "Packagegroup for internal organization"
DESCRIPTION:${PN}-logging-libs = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-logging-libs = ""
RDEPENDS:${INTERNAL_PG}-logging-libs = " \
rabbitmq-c \
paho-mqtt-c \
paho-mqtt-cpp \
python3-paho-mqtt \
"

####################

PACKAGES += "${INTERNAL_PG}-luks"
SUMMARY:${PN}-luks = "Packagegroup for internal organization"
DESCRIPTION:${PN}-luks = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-luks = ""
RDEPENDS:${INTERNAL_PG}-luks = " \
cryptsetup \
libdevmapper \
"

####################

PACKAGES += "${INTERNAL_PG}-lvm2"
SUMMARY:${PN}-lvm2= "Packagegroup for internal organization"
DESCRIPTION:${PN}-lvm2 = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-lvm2 = ""
RDEPENDS:${INTERNAL_PG}-lvm2 = " \
${INTERNAL_PG}-udev \
lvm2 \
lvm2-udevrules \
libdevmapper \
"

####################

# PACKAGES += "${INTERNAL_PG}-connman"
SUMMARY:${PN}-connman = "Packagegroup for internal organization"
DESCRIPTION:${PN}-connman = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-connman = ""
RDEPENDS:${INTERNAL_PG}-connman = " \
connman \
ofono \
"
RDEPENDS:${INTERNAL_PG}-connman:distro-gui += "connman-gnome"

####################

PACKAGES += "${INTERNAL_PG}-networkmanager"
SUMMARY:${PN}-networkmanager = "Packagegroup for internal organization"
DESCRIPTION:${PN}-networkmanager = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-networkmanager = ""
RDEPENDS:${INTERNAL_PG}-networkmanager = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'modemmanager', '', d)} \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'networking-layer', 'networkmanager', '', d)} \
"

####################

# Mutually exclusive ${INTERNAL_PG}-connman OR ${INTERNAL_PG}-networkmanager

PACKAGES += "${INTERNAL_PG}-network-core"
SUMMARY:${PN}-network-core = "Packagegroup for internal organization"
DESCRIPTION:${PN}-network-core = "Packagegroup for internal organizaton"
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
SUMMARY:${PN}-network = "Packagegroup for internal organization"
DESCRIPTION:${PN}-network = "Packagegroup for internal organizaton"
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
SUMMARY:${PN}-network-extras = "Packagegroup for internal organization"
DESCRIPTION:${PN}-network-extras = "Packagegroup for internal organizaton"
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
wireshark \
"

####################

PACKAGES += "${INTERNAL_PG}-ostree"
SUMMARY:${PN}-ostree = "Packagegroup for internal organization"
DESCRIPTION:${PN}-ostree = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-ostree = ""
RDEPENDS:${INTERNAL_PG}-ostree = " \
ostree \
ostree-booted \
ostree-kernel \
ostree-initramfs \
ostree-devicetrees \
ostree-switchroot \
"
# rpm-ostree

####################

PACKAGES += "${INTERNAL_PG}-test-framework"
SUMMARY:${PN}-test-framework = "Packagegroup for internal organization"
DESCRIPTION:${PN}-test-framework = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-test-framework = ""
RDEPENDS:${INTERNAL_PG}-test-framework:distro-testfw = " \
python3-robotframework \
python3-robotframework-seriallibrary \
"

####################

PACKAGES += "${INTERNAL_PG}-udev"
SUMMARY:${PN}-udev = "Packagegroup for internal organization"
DESCRIPTION:${PN}-udev = "Packagegroup for internal organizaton"
FILES:${INTERNAL_PG}-udev = ""
RDEPENDS:${INTERNAL_PG}-udev = " \
udev \
udev-extraconf \
"
