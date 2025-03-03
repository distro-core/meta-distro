# conf/distro/include/distro-providers.inc

# Used to pin specific packages and versions

PREFERRED_PROVIDER_virtual/runc ??= "runc-opencontainers"

PREFERRED_RPROVIDER_network-configuration ??= "networkd-dhcp-conf"
PREFERRED_RPROVIDER_virtual/psplash ??= "psplash"

# PREFERRED_RPROVIDER_util-linux-more = "busybox"

PREFERRED_RPROVIDER_util-linux-fsck-native = "util-linux-fsck-native"
PREFERRED_RPROVIDER_util-linux-agetty-native = "util-linux-agetty-native"
PREFERRED_RPROVIDER_util-linux-mount-native = "util-linux-mount-native"
PREFERRED_RPROVIDER_util-linux-umount-native = "util-linux-umount-native"

# preferred versions
# PREFERRED_VERSION_shim = "15.8"
PREFERRED_VERSION_wpa-supplicant = "2.11"

# Explicitly removed packages
# PACKAGE_EXCLUDE:append = " util-linux-more"

# distro-tiny default providers
PREFERRED_PROVIDER_virtual/containerd:distro-tiny ??= ""

# QA sanity overrides
# INSANE_SKIP:cni ??= "ldflags ldflags already-stripped textrel"
# INSANE_SKIP:fwupd-ptest ??= "buildpaths"
# INSANE_SKIP:gettext-ptest ??= "build-deps"
# INSANE_SKIP:libjcat-ptest ??= "buildpaths"
# INSANE_SKIP:libvirt ??= "build-deps"
# INSANE_SKIP:libvirt-python ??= "buildpaths"
# INSANE_SKIP:m4-ptest ??= "build-deps"
# INSANE_SKIP:python3-ptest ??= "build-deps"
INSANE_SKIP:bash-completion-ptest ??= "build-deps"
INSANE_SKIP:bash-ptest ??= "build-deps"
INSANE_SKIP:expat-ptest ??= "build-deps file-rdeps"
INSANE_SKIP:fuse3 ??= "build-deps"
INSANE_SKIP:gawk-ptest ??= "build-deps"
INSANE_SKIP:gcab ??= "buildpaths"
INSANE_SKIP:geary ??= "buildpaths"
INSANE_SKIP:geary-dbg ??= "buildpaths"
INSANE_SKIP:glib-2.0-ptest ??= "build-deps"
INSANE_SKIP:gnome-tweaks ??= "buildpaths"
INSANE_SKIP:gnupg-ptest ??= "build-deps"
INSANE_SKIP:gnutls-ptest ??= "build-deps file-rdeps"
INSANE_SKIP:grub-common ??= "build-deps"
INSANE_SKIP:libcamera ??= "32bit-time"
INSANE_SKIP:libcheck-ptest ??= "build-deps file-rdeps"
INSANE_SKIP:libgpg-error-ptest ??= "build-deps"
INSANE_SKIP:libpcre-ptest ??= "build-deps"
INSANE_SKIP:libseccomp-ptest ??= "build-deps file-rdeps"
INSANE_SKIP:lua-ptest ??= "build-deps file-rdeps"
INSANE_SKIP:mozjs ??= "32bit-time"
INSANE_SKIP:openrc-stub = "usrmerge"
INSANE_SKIP:pipewire ??= "32bit-time"
INSANE_SKIP:popt-ptest ??= "build-deps"
INSANE_SKIP:strace-ptest ??= "build-deps"
INSANE_SKIP:volume-key ??= "buildpaths"
INSANE_SKIP:zlib-ptest ??= "build-deps"

INSANE_SKIP:rust-crosssdk ??= "uppercase-pn"

# ---
