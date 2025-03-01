# conf/distro/include/distro-mirrors.inc

# git and tarball generation
BB_GIT_SHALLOW = "1"
BB_GIT_SHALLOW_DEPTH = "1"
BB_GENERATE_MIRROR_TARBALLS = "1"
BB_GENERATE_SHALLOW_TARBALLS = "1"
BB_SIGNATURE_HANDLER = "OEBasicHash"

SSTATE_MIRROR_ALLOW_NETWORK = "1"

EXTRA_PREMIRRORS ??= ""
PREMIRRORS:prepend = "${EXTRA_PREMIRRORS} "

EXTRA_SSTATE_MIRRORS ??= ""
SSTATE_MIRRORS:prepend = "${EXTRA_SSTATE_MIRRORS} "

BB_HASHSERVE_UPSTREAM ?= "hashserv.distro-core.brainhoard.com:8686"
PRSERV_UPSTREAM ?= "prserv.distro-core.brainhoard.com:8585"

# PACKAGE_FEED_URIS = "https://packages.distro-core.brainhoard.com/${MACHINE}/release packages.distro-core.brainhoard.com/${MACHINE}/updates"
# PACKAGE_FEED_BASE_PATHS = "rpm rpm-dev"
# PACKAGE_FEED_ARCHS = "all corei7-64"

# ---
