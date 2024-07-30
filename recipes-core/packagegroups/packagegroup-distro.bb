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

# OVERRIDES             Description
# none                  default packagegroup, required even if empty
# :distro-guest         additions for virtual machine guests
# :distro-gui           additions for gnome, xfce, wayland, x11
# :distro-kubernetes    additions for kubernetes, k3s
# :distro-kvm           additions for kvm, lxc, libvirt
# :distro-testfw        additions for test frameworks
# :libc-glibc           additions for runtime glibc, locales
# :libc-musl            additions for runtime musl
# :<distro_name>        additions for specific DISTRO
# :<machine_arch>       additions for specific MACHINE

PACKAGE_ARCH = "${TUNE_PKGARCH}"

# packagegroups to organize within ${PN}
INTERNAL_PG = "${PN}-local"

EXCLUDE_FROM_WORLD = "1"

inherit packagegroup

################################################################################
# LICENSE open source packages
################################################################################

# internal-pattern
# PACKAGES += "${INTERNAL_PG}-pattern"
# SUMMARY:${INTERNAL_PG}-pattern = "internal packagegroup use"
# FILES:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern:OVERRIDES = ""

# external-pattern
# PACKAGES += "${PN}-pattern"
# SUMMARY:${PN}-pattern = "DISTRO use"
# FILES:${PN}-pattern = ""
# RDEPENDS:${PN}-pattern = ""
# RDEPENDS:${PN}-pattern:OVERRIDES = ""

FILES:${PN} = ""
RDEPENDS:${PN} = ""

####################

PACKAGES += "${PN}-core"
SUMMARY:${PN}-core = "DISTRO use"
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
${INTERNAL_PG}-tpm \
${INTERNAL_PG}-tpm2 \
${INTERNAL_PG}-udev \
${PN}-boot-systemd \
${PN}-machine-core \
${PN}-systemd \
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
kbd kbd-consolefonts kbd-keymaps kbd-unimaps \
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

####################

PACKAGES += "${PN}-core-sdk"
SUMMARY:${PN}-core-sdk = "DISTRO use"
FILES:${PN}-core-sdk = ""
RDEPENDS:${PN}-core-sdk = " \
packagegroup-core-sdk \
packagegroup-core-standalone-sdk-target \
"

####################

PACKAGES += "${PN}-full"
SUMMARY:${PN}-full = "DISTRO use"
FILES:${PN}-full = ""
RDEPENDS:${PN}-full = " \
${INTERNAL_PG}-extras \
${INTERNAL_PG}-network-extras \
"
RDEPENDS:${PN}-full:distro-gui += "${PN}-gui-gnome"
RDEPENDS:${PN}-full:distro-gui += "${PN}-gui-xfce"

####################

PACKAGES += "${INTERNAL_PG}-gui-core"
SUMMARY:${INTERNAL_PG}-gui-core = "internal packagegroup use"
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
SUMMARY:${PN}-gui-gnome = "DISTRO use"
FILES:${PN}-gui-gnome = ""
RDEPENDS:${PN}-gui-gnome = ""
RDEPENDS:${PN}-gui-gnome:distro-gui = " \
${INTERNAL_PG}-gui-core \
packagegroup-gnome-apps \
packagegroup-gnome-desktop \
"

####################

PACKAGES += "${PN}-gui-xfce"
SUMMARY:${PN}-gui-xfce = "DISTRO use"
FILES:${PN}-gui-xfce = ""
RDEPENDS:${PN}-gui-xfce = ""
RDEPENDS:${PN}-gui-xfce:distro-gui = " \
${INTERNAL_PG}-gui-core \
packagegroup-xfce-base \
packagegroup-xfce-extended \
packagegroup-xfce-multimedia \
"

####################

PACKAGES += "${PN}-systemd"
SUMMARY:${PN}-systemd = "DISTRO use"
FILES:${PN}-systemd = ""
RDEPENDS:${PN}-systemd = " \
${INTERNAL_PG}-udev \
systemd \
systemd-analyze \
systemd-conf \
systemd-container \
systemd-extra-utils \
systemd-kernel-install \
systemd-udev-rules \
"

####################

# PACKAGES += "${PN}-boot-grub-efi"
# SUMMARY:${PN}-boot-grub-efi = "DISTRO use"
# FILES:${PN}-boot-grub-efi = ""
# RDEPENDS:${PN}-boot-grub-efi = " \
# ${@bb.utils.contains('BBFILE_COLLECTIONS', 'efi-secure-boot', 'efitools mokutil seloader shim', '', d)} \
# ${INTERNAL_PG}-boot-efi-tools \
# grub-efi \
# grub-bootconf \
# "
# RRECOMMENDS:${PN}-boot-grub-efi = ""

####################

PACKAGES += "${PN}-boot-systemd"
SUMMARY:${PN}-boot-systemd = "DISTRO use"
FILES:${PN}-boot-systemd = ""
RDEPENDS:${PN}-boot-systemd = " \
${INTERNAL_PG}-boot-efi-tools \
refind-bin \
systemd-boot \
systemd-bootconf \
"
RRECOMMENDS:${PN}-boot-systemd = "initramfs-framework-sota"

############################################################
# LOCAL packagegroups are for grouping of packages into
# a collection of similar or related packages
############################################################

# internal-pattern
# PACKAGES += "${INTERNAL_PG}-pattern"
# SUMMARY:${INTERNAL_PG}-pattern = "internal packagegroup use"
# FILES:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern = ""
# RDEPENDS:${INTERNAL_PG}-pattern:OVERRIDES = ""

PACKAGES += "${INTERNAL_PG}-extras"
SUMMARY:${INTERNAL_PG}-extras = "internal packagegroup use"
FILES:${INTERNAL_PG}-extras = ""
RDEPENDS:${INTERNAL_PG}-extras = " \
htop \
iftop \
util-linux-fdisk \
tzdata \
parted \
"
# lmsensors lmsensors-config

####################

PACKAGES += "${INTERNAL_PG}-boot-efi-tools"
SUMMARY:${INTERNAL_PG}-boot-efi-tools = "internal packagegroup use"
FILES:${INTERNAL_PG}-boot-efi-tools = ""
RDEPENDS:${INTERNAL_PG}-boot-efi-tools = " \
efibootmgr \
efivar \
"

####################

PACKAGES += "${INTERNAL_PG}-docker"
SUMMARY:${INTERNAL_PG}-docker = "internal packagegroup use"
FILES:${INTERNAL_PG}-docker = ""
RDEPENDS:${INTERNAL_PG}-docker = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'docker-moby containerd-opencontainers virtual-runc slirp4netns', '', d)} \
"

####################

# PACKAGES += "${INTERNAL_PG}-k3s"
# SUMMARY:${INTERNAL_PG}-k3s = "internal packagegroup use"
# FILES:${INTERNAL_PG}-k3s = ""
# RDEPENDS:${INTERNAL_PG}-k3s = ""
# RDEPENDS:${INTERNAL_PG}-k3s:distro-kubernetes = " \
# ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'k3s-agent k3s-server', '', d)} \
# "

####################

# PACKAGES += "${INTERNAL_PG}-kubernetes"
# SUMMARY:${INTERNAL_PG}-kubernetes = "internal packagegroup use"
# FILES:${INTERNAL_PG}-kubernetes = ""
# RDEPENDS:${INTERNAL_PG}-kubernetes = ""
# RDEPENDS:${INTERNAL_PG}-kubernetes:distro-kubernetes = " \
# ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'kubernetes', '', d)} \
# "

####################

PACKAGES += "${INTERNAL_PG}-lxc"
SUMMARY:${INTERNAL_PG}-lxc = "internal packagegroup use"
FILES:${INTERNAL_PG}-lxc = ""
RDEPENDS:${INTERNAL_PG}-lxc = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'lxc lxc-networking lxc-templates lxcfs', '', d)} \
"
# unavailable libc-musl
RDEPENDS:${INTERNAL_PG}-lxc:remove:libc-musl = ""

####################

PACKAGES += "${INTERNAL_PG}-kvm-qemu"
SUMMARY:${INTERNAL_PG}-kvm-qemu = "internal packagegroup use"
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
libvirt \
libxml2 \
ncurses \
qemu \
usbredir \
yajl \
"

####################

PACKAGES += "${INTERNAL_PG}-podman"
SUMMARY:${INTERNAL_PG}-podman = "internal packagegroup use"
FILES:${INTERNAL_PG}-podman = ""
RDEPENDS:${INTERNAL_PG}-podman = " \
${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', 'podman virtual-runc slirp4netns', '', d)} \
"

####################

PACKAGES += "${INTERNAL_PG}-logging"
SUMMARY:${INTERNAL_PG}-logging = "internal packagegroup use"
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
SUMMARY:${INTERNAL_PG}-logging-libs = "internal packagegroup use"
FILES:${INTERNAL_PG}-logging-libs = ""
RDEPENDS:${INTERNAL_PG}-logging-libs = " \
rabbitmq-c \
paho-mqtt-c \
paho-mqtt-cpp \
python3-paho-mqtt \
"

####################

PACKAGES += "${INTERNAL_PG}-luks"
SUMMARY:${INTERNAL_PG}-luks = "internal packagegroup use"
FILES:${INTERNAL_PG}-luks = ""
RDEPENDS:${INTERNAL_PG}-luks = " \
cryptsetup \
libdevmapper \
"

####################

PACKAGES += "${INTERNAL_PG}-lvm2"
SUMMARY:${INTERNAL_PG}-lvm2 = "internal packagegroup use"
FILES:${INTERNAL_PG}-lvm2 = ""
RDEPENDS:${INTERNAL_PG}-lvm2 = " \
${INTERNAL_PG}-udev \
lvm2 \
lvm2-udevrules \
libdevmapper \
"

####################

# PACKAGES += "${INTERNAL_PG}-connman"
# SUMMARY:${INTERNAL_PG}-connman = "internal packagegroup use"
# FILES:${INTERNAL_PG}-connman = ""
# RDEPENDS:${INTERNAL_PG}-connman = " \
# connman \
# ofono \
# "
# RDEPENDS:${INTERNAL_PG}-connman:distro-gui += "connman-gnome"

####################

PACKAGES += "${INTERNAL_PG}-networkmanager"
SUMMARY:${INTERNAL_PG}-networkmanager = "internal packagegroup use"
FILES:${INTERNAL_PG}-networkmanager = ""
RDEPENDS:${INTERNAL_PG}-networkmanager = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'modemmanager', '', d)} \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'networking-layer', 'networkmanager', '', d)} \
"

####################

PACKAGES += "${INTERNAL_PG}-network-core"
SUMMARY:${INTERNAL_PG}-network-core = "internal packagegroup use"
FILES:${INTERNAL_PG}-network-core = ""
RDEPENDS:${INTERNAL_PG}-network-core = " \
${@bb.utils.contains('BBFILE_COLLECTIONS', 'openembedded-layer', 'libmbim libqmi', '', d)} \
${INTERNAL_PG}-networkmanager \
packagegroup-core-ssh-openssh \
ethtool \
iproute2 \
iptables \
nftables \
openssh \
openssl \
ifupdown \
iputils \
"
RCONFLICTS:${INTERNAL_PG}-network-core = " \
packagegroup-core-ssh-dropbear \
"

####################

PACKAGES += "${INTERNAL_PG}-network"
SUMMARY:${INTERNAL_PG}-network = "internal packagegroup use"
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
SUMMARY:${INTERNAL_PG}-network-extras = "internal packagegroup use"
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
SUMMARY:${INTERNAL_PG}-ostree = "internal packagegroup use"
FILES:${INTERNAL_PG}-ostree = ""
RDEPENDS:${INTERNAL_PG}-ostree = " \
ostree \
ostree-booted \
ostree-kernel \
ostree-initramfs \
ostree-devicetrees \
ostree-switchroot \
"

####################

PACKAGES += "${INTERNAL_PG}-test-framework"
SUMMARY:${INTERNAL_PG}-test-framework = "internal packagegroup use"
FILES:${INTERNAL_PG}-test-framework = ""
RDEPENDS:${INTERNAL_PG}-test-framework:distro-testfw = " \
python3-robotframework \
python3-robotframework-seriallibrary \
"

####################

PACKAGES += "${INTERNAL_PG}-tpm"
SUMMARY:${INTERNAL_PG}-tpm = "internal packagegroup use"
FILES:${INTERNAL_PG}-tpm = ""
RDEPENDS:${INTERNAL_PG}-tpm = " \
tpm-tools \
trousers \
tpm-quote-tools \
openssl-tpm-engine \
pcr-extend \
"

####################

PACKAGES += "${INTERNAL_PG}-tpm2"
SUMMARY:${INTERNAL_PG}-tpm2 = "internal packagegroup use"
FILES:${INTERNAL_PG}-tpm2 = ""
RDEPENDS:${INTERNAL_PG}-tpm2 = " \
tpm2-tools \
trousers \
tpm2-tss \
libtss2-mu \
libtss2-tcti-device \
libtss2-tcti-mssim \
libtss2 \
tpm2-abrmd \
tpm2-pkcs11 \
tpm2-openssl \
tpm2-tss-engine \
tpm2-tss-engine-engines \
"

####################

PACKAGES += "${INTERNAL_PG}-udev"
SUMMARY:${INTERNAL_PG}-udev = "internal packagegroup use"
FILES:${INTERNAL_PG}-udev = ""
RDEPENDS:${INTERNAL_PG}-udev = " \
udev \
udev-extraconf \
udev-hwdb \
"
