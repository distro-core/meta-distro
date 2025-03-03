# conf/distro/include/distro-common.inc

# Used to define common build settings

# require conf/distro/include/yocto-uninative.inc
# require conf/distro/include/no-static-libs.inc
require conf/distro/include/gcsections.inc
# require conf/distro/include/security_flags.inc

require conf/distro/include/distro-clang.inc
require conf/distro/include/distro-go.inc
require conf/distro/include/distro-mingw.inc
require conf/distro/include/distro-rust.inc

require conf/distro/include/distro-mirrors.inc
require conf/distro/include/distro-providers.inc
require conf/distro/include/distro-useradd.inc

# image_types
IMAGE_CLASSES += "image_types_extend"

# secureboot keys
# INHERIT += "${@bb.utils.contains('BBFILE_COLLECTIONS', 'signing-key', 'user-key-store', '', d)}"
# require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'signing-key', 'files/user-keys/keys.conf', '', d)}

# if "", disables online connectivity checks
# CONNECTIVITY_CHECK_URIS = ""

# number of cpu threads allocated to bitbake
# BB_NUMBER_THREADS ?= "${@int(oe.utils.cpu_count() * 80 / 100)}"
# number of cpu threads allocated to tasks parallel make
# PARALLEL_MAKE ?= "-j ${@int(oe.utils.cpu_count() * 80 /100)}"
# lower than nominal priority, allows system functions to run
BB_NICE_LEVEL ?= "5"
# lower than nominal priority, allows system functions to run
BB_TASK_NICE_LEVEL ?= "5"
# if "1", bbappends without recipe are warning only
BB_DANGLINGAPPENDS_WARNONLY = "1"
# if set, list of recipes that may PROVIDES the same package
# BB_MULTI_PROVIDER_ALLOWED = "virtual/kernel"
# if set, number of seconds --idle-timeout before server shutdown
BB_SERVER_TIMEOUT = "60"

# meta-signing-key UEFI variables GUID
VENDOR_UUID = "0988eff2-6e7f-4fba-8e81-0841fc437703"

# GLIBC_GENERATE_LOCALES += "en_US.UTF-8"
# image language
# IMAGE_LINGUAS += "en-us"
# CORE_IMAGE_EXTRA_INSTALL += "glibc-locale-en-us"

# if "1", uses DEBUG_OPTIMIZATION flags
DEBUG_BUILD ?= "0"
# compiler optimization flags
FULL_OPTIMIZATION ?= "-O3 ${DEBUG_FLAGS}"
DEBUG_OPTIMIZATION ?= "-Og ${DEBUG_FLAGS}"
SELECTED_OPTIMIZATION = "${@d.getVar(oe.utils.vartrue('DEBUG_BUILD', 'DEBUG_OPTIMIZATION', 'FULL_OPTIMIZATION', d))}"

# set artifacts output paths
DEPLOY_DIR_IPK = "${DEPLOY_DIR}/ipk"
DEPLOY_DIR_RPM = "${DEPLOY_DIR}/rpm"
DEPLOY_DIR_DEB = "${DEPLOY_DIR}/deb"
DEPLOY_DIR_IMAGE = "${DEPLOY_DIR}/images/${MACHINE}"
DEPLOY_DIR_TOOLS = "${DEPLOY_DIR}/tools"
# DEPLOY_DIR_SRC = "${DEPLOY_DIR}/src"
# SSTATE_ALLOW_OVERLAP_FILES += "${DEPLOY_DIR_IMAGE}/microcode"

# runtime
TCMODE ??= "default"

# if "1", do not install package recommendations
NO_RECOMMENDATIONS = "1"

# base-passwd, root home ~root
ROOT_HOME = "/root"

# if "no", /var/log is persistent
VOLATILE_LOG_DIR = "no"
# if "no", /var/tmp is persistent
VOLATILE_TMP_DIR = "no"

# rm_work
INHERIT += "rm_work"
# optional. if set, package work is not removed
# RM_WORK_EXCLUDE = "${INITRAMFS_IMAGE}"

# build statistics
# INHERIT += "buildstats buildstats-summary"
# BB_HEARTBEAT_EVENT = "1"
# BB_LOG_HOST_STAT_CMDS_INTERVAL = ""
# BB_LOG_HOST_STAT_CMDS_FAILURE = ""
# BB_LOG_HOST_STAT_ON_FAILURE = ""

# Scale down jobs/threads when memory per CPU core is low
# INHERIT += "mem-per-cpu-scaling"

# cve-check (database update can take signifigant time)
# INHERIT += "cve-check" # add to environment EXTRA_USER_CLASSES
require conf/distro/include/cve-extra-exclusions.inc
require conf/distro/include/distro-cve-extra-exclusions.inc
# if "0", patched cve are not reported
CVE_CHECK_REPORT_PATCHED = "0"
# if "1", warnings are issued
CVE_CHECK_SHOW_WARNINGS = "1"
# optional, if set, packages are skipped, allow list
# CVE_CHECK_SKIP_RECIPE = ""
# cve-update-nvd2-native.bb contains update logic
# if set, frequency of database updates, can be signifigant time, default 24h, negative value off (seconds)
CVE_DB_UPDATE_INTERVAL = "604800"

# create-spdx
INHERIT:remove = "create-spdx"
# if "1", output spdx files will be formatted
SPDX_PRETTY = "1"
# if "1", output spdx files includes [file-information section](https://spdx.github.io/spdx-spec/v2.3/file-information/)
SPDX_INCLUDE_SOURCES = "0"
# if "1", bitbake will create source files archive for each package
SPDX_ARCHIVE_SOURCES = "0"
# if "1", bitbake will create output binary archive for each package
SPDX_ARCHIVE_PACKAGED = "0"

# buildhistory
INHERIT:remove = "buildhistory"
# optional. if "0", bitbake will not commit buildhistory
BUILDHISTORY_COMMIT = "0"

# buildinfo ${sysconfdir}/buildinfo
INHERIT += "image-buildinfo"
IMAGE_BUILDINFO_FILE = "${sysconfdir}/buildinfo"

# license archives management
INHERIT += "license"
# if "1", copy licenses to image
COPY_LIC_DIRS = "0"
# if "1", copy license manifest to image
COPY_LIC_MANIFEST = "0"
# if set, licenses to exclude from source archives
COPYLEFT_LICENSE_EXCLUDE = "CLOSED Proprietary"
# if set, recipe types to include in source archives
COPYLEFT_RECIPE_TYPES = "target*"
# if "1", create license packages
LICENSE_CREATE_PACKAGE = "0"
# license flags
LICENSE_FLAGS_ACCEPTED:remove = "commercial_ffmpeg"
QT_COMMERCIAL_MODULES = "0"
# if "commercial", accept commercial sw such as ffmpeg
LICENSE_FLAGS_ACCEPTED += "commercial"

# distro-image-features.bbclass
INHERIT += "distro-image-features"

# distro-image-license-audit.bbclass
INHERIT += "distro-image-license-audit"
# if "", disables incompatible licenses check
INCOMPATIBLE_LICENSE += "AGPL-3.0-only AGPL-3.0-or-later GPL-3.0-only GPL-3.0-or-later LGPL-3.0-only LGPL-3.0-or-later"
# if "", incompatible licenses check has no exceptions
INCOMPATIBLE_LICENSE_EXCEPTIONS += "${DISTRO_LICENSE_EXCEPTIONS}"
# QA warning/error remove license-incompatible checks and output
# ERROR_QA:remove = "license-incompatible"
# WARN_QA:remove = "license-incompatible"

# python exclude sources with setup.py
# SETUPTOOLS_BUILD_ARGS = "--exclude-source-files"

# inherit remove .la, override in package REMOVE_LIBTOOL_LA = "0"
INHERIT += "remove-libtool"

# package management (deb, ipk, rpm)
# PACKAGE_CLASSES += "package_ipk"
# PACKAGE_CLASSES += "package_deb"
# PACKAGE_CLASSES += "package_rpm"
# PACKAGE_CLASSES += "sign_ipk"
# PACKAGE_CLASSES += "sign_rpm"
# PACKAGE_CLASSES += "sign_package_feed"
# INHERIT += "${PACKAGE_CLASSES}"

# gobject introspection
GI_DATA_ENABLED = "True"
DISTRO_FEATURES:append = " gobject-introspection-data"
# MACHINE_FEATURES:append = " qemu-usermode"

# meta-secure-core
INHERIT += "${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'user-key-store', '', d)}"

# meta-intel uefi-sign.bbclass
# IMAGE_FEATURES[validitems] += "secureboot"
# IMAGE_FEATURES += "secureboot"
# SECURE_BOOT_SIGNING_CERT ?= "${TOPDIR}/../../layers/meta-distro/files/user-keys/uefi_sb_keys/db.crt"
# SECURE_BOOT_SIGNING_KEY ?= "${TOPDIR}/../../layers//meta-distro/files/user-keys/uefi_sb_keys/db.key"

# repo manifest references
REPO_MANIFEST_URL ?= "ENVIRONMENT-UNSET"
REPO_MANIFEST_REF ?= "ENVIRONMENT-UNSET"
REPO_MANIFEST_FILE ?= "ENVIRONMENT-UNSET"
REPO_MANIFEST_XML ?= "ENVIRONMENT-UNSET"

# ---
