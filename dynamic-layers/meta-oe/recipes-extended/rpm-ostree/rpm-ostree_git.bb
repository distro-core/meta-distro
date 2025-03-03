SUMMARY = "Hybrid image/package system with atomic upgrades and package layering"
DESCRIPTION = "rpm-ostree is a hybrid image/package system that combines OSTree and RPM, \
               providing transactional upgrades and package layering for atomic systems."
HOMEPAGE = "https://github.com/coreos/rpm-ostree"
LICENSE = "GPL-2.0-or-later & LGPL-2.0-or-later & (Apache-2.0 | MIT)"
LIC_FILES_CHKSUM = "file://COPYING;md5=eb1e647653adb31b25e88c7e5e0e4514"

# Source from the GitHub repository
SRC_URI = "git://github.com/coreos/rpm-ostree.git;protocol=https;branch=main"

# Specify the version (Git commit or tag). Since this is a git fetch, use PV and SRCREV.
PV = "git${SRCPV}"
SRCREV = "8e1518ac6b1d17da0d20e18f6430171ea5fdb53a"
# SRCREV = "HEAD"  # Use a specific commit hash for reproducibility, e.g., "5a13126e71db2da16fe1659cfb8c4ae7275e560c"

# Source directory name after fetching
S = "${WORKDIR}/git"

# Dependencies required to build rpm-ostree (Rust enabled)
DEPENDS = " \
    ostree \
    libdnf \
    rpm \
    glib-2.0 \
    json-glib \
    curl \
    libarchive \
    zlib \
    systemd \
    polkit \
    gobject-introspection-native \
    python3-native \
    cargo-native \
    rust-native \
"

# Runtime dependencies
RDEPENDS:${PN} = " \
    ostree \
    libdnf \
    rpm \
    systemd \
    polkit \
"

# Inherit necessary classes for building, including Rust support
inherit autotools pkgconfig systemd cargo

# Extra configuration options for autoreconf
EXTRA_OECONF = " \
    --with-systemd \
    --with-polkit \
"

# Ensure autoreconf works correctly
do_configure:prepend() {
    # Run autoreconf to regenerate configure script
    cd ${S}
    autoreconf -i -f
}

# Compile step (Rust and autotools combined)
do_compile() {
    oe_runmake
}

# Install step
do_install() {
    oe_runmake DESTDIR=${D} install

    # Install systemd service files if present
    if [ -d ${S}/systemd ]; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${S}/systemd/*.service ${D}${systemd_system_unitdir}
    fi
}

# Specify installed files
FILES:${PN} += " \
    ${bindir}/rpm-ostree \
    ${libdir}/rpm-ostree* \
    ${systemd_system_unitdir}/ \
"

# Systemd service handling
SYSTEMD_SERVICE:${PN} = "rpm-ostree.service"
SYSTEMD_AUTO_ENABLE = "disable"

# Avoid QA issues (e.g., missing dependencies or file permissions)
INSANE_SKIP:${PN} += "dev-so"

# Notes for users
BBCLASSEXTEND = "native nativesdk"
