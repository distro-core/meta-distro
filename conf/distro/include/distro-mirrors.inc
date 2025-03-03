# conf/distro/include/distro-mirrors.inc

# git and tarball generation
BB_GIT_SHALLOW = "1"
BB_GIT_SHALLOW_DEPTH = "1"
BB_GENERATE_MIRROR_TARBALLS = "1"
BB_GENERATE_SHALLOW_TARBALLS = "1"
BB_SIGNATURE_HANDLER = "OEBasicHash"

SSTATE_MIRROR_ALLOW_NETWORK = "1"

# read from the environment and set mirrors as needed

# BB_HASHSERVE ?= "unix://${TOPDIR}/hashserv.sock"
# PESERV_HOST ?= "unix://${TOPDIR}/peserv.sock"

python () {
    import os
    extra_premirrors = d.getVar('EXTRA_PREMIRRORS', True)
    if extra_premirrors:
        premirrors = d.getVar('PREMIRRORS', True) or ""
        d.setVar('PREMIRRORS', extra_premirrors + " " + premirrors)
    extra_sstate_mirrors = d.getVar('EXTRA_SSTATE_MIRRORS', True)
    if extra_sstate_mirrors:
        sstate_mirrors = d.getVar('SSTATE_MIRRORS', True) or ""
        d.setVar('SSTATE_MIRRORS', extra_sstate_mirrors + " " + sstate_mirrors)
}

# PRSERV_HOST = "localhost:0"

# BB_HASHSERVE_UPSTREAM ?= "localhost.localdomain:8686"
# PRSERV_UPSTREAM ?= "localhost.localdomain:8585"

# PACKAGE_FEED_URIS = "https://localhost.localdomain/${MACHINE}/release localhost.localdomain/${MACHINE}/updates"
# PACKAGE_FEED_BASE_PATHS = "rpm rpm-dev"
# PACKAGE_FEED_ARCHS = "all corei7-64"

# ---
