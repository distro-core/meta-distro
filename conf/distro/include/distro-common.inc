# conf/distro/include/distro-common.inc

# Used to define common build settings

# require conf/distro/include/yocto-uninative.inc
# require conf/distro/include/no-static-libs.inc
require conf/distro/include/gcsections.inc

require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'clang-layer', 'conf/distro/include/distro-clang.inc', '', d)}
require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'meta-mingw', 'conf/distro/include/distro-mingw.inc', '', d)}
require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'rust-layer', 'conf/distro/include/distro-rust.inc', '', d)}

require conf/distro/include/distro-mirrors.inc
require conf/distro/include/distro-useradd.inc
require conf/distro/include/distro-providers.inc

# image_types
IMAGE_CLASSES += "features_check"
IMAGE_CLASSES += "image_types_extend"
IMAGE_CLASSES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'image_types_ostree_extend', '', d)}"
IMAGE_CLASSES += "${@bb.utils.contains('DISTRO_FEATURES', 'sota', 'image_types_ota_extend', '', d)}"
IMAGE_CLASSES += "${@bb.utils.contains('DISTRO_FEATURES', 'usrmerge', 'image-usr-share-factory','',d)}"

# secureboot keys
# INHERIT += "${@bb.utils.contains('BBFILE_COLLECTIONS', 'signing-key', 'user-key-store', '', d)}"
# require files/user-keys/keys.conf

# if "", disables online connectivity checks
# CONNECTIVITY_CHECK_URIS = ""

# number of cpu threads allocated to bitbake (75%)
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

# meta-signing-key UEFI variables GUID
VENDOR_UUID = "0988eff2-6e7f-4fba-8e81-0841fc437703"

# GLIBC_GENERATE_LOCALES += "en_US.UTF-8"
# image language
# IMAGE_LINGUAS += "en-us"
# CORE_IMAGE_EXTRA_INSTALL += "glibc-locale-en-us"

# if "1", uses DEBUG_OPTIMIZATION flags
DEBUG_BUILD ?= "0"
# compiler optimization flags
FULL_OPTIMIZATION ?= "-O3 -pipe ${DEBUG_FLAGS}"
DEBUG_OPTIMIZATION ?= "-Og -pipe ${DEBUG_FLAGS}"
SELECTED_OPTIMIZATION = "${@d.getVar(oe.utils.vartrue('DEBUG_BUILD', 'DEBUG_OPTIMIZATION', 'FULL_OPTIMIZATION', d))}"

# set artifacts output paths
DEPLOY_DIR_IPK = "${DEPLOY_DIR}/ipk"
DEPLOY_DIR_RPM = "${DEPLOY_DIR}/rpm"
DEPLOY_DIR_DEB = "${DEPLOY_DIR}/deb"
DEPLOY_DIR_IMAGE = "${DEPLOY_DIR}/images"
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
RM_WORK_EXCLUDE = "${INITRAMFS_IMAGE}"

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

# buildinfo ${sysconfdir}/build
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

# python exclude sources with setup.py
# SETUPTOOLS_BUILD_ARGS = "--exclude-source-files"

# distro-license-audit INCOMPATIBLE_LICENSE
INHERIT += "distro-license-audit"

# distro-image-features
INHERIT += "distro-image-features"

# QA warning/error configuration, override in package INSANE_SKIP = "flag"
# WARN_QA += ""
# ERROR_QA += ""

# inherit remove .la, override in package REMOVE_LIBTOOL_LA = "0"
# INHERIT += "remove-libtool"

# package management (deb, ipk, rpm)
# PACKAGE_CLASSES += "package_ipk"
# PACKAGE_CLASSES += "package_deb"
# PACKAGE_CLASSES += "package_rpm"
# PACKAGE_CLASSES += "sign_ipk"
# PACKAGE_CLASSES += "sign_rpm"
# PACKAGE_CLASSES += "sign_package_feed"
# INHERIT += "${PACKAGE_CLASSES}"

# gobject introspection
DISTRO_FEATURES:append = " gobject-introspection-data"
# MACHINE_FEATURES:append = " qemu-usermode"

# meta-intel uefi-sign.bbclass
# IMAGE_FEATURES[validitems] += "secureboot"
# IMAGE_FEATURES += "secureboot"
# SECURE_BOOT_SIGNING_CERT ?= "${TOPDIR}/../../layers/meta-distro/files/user-keys/uefi_sb_keys/db.crt"
# SECURE_BOOT_SIGNING_KEY ?= "${TOPDIR}/../../layers//meta-distro/files/user-keys/uefi_sb_keys/db.key"

# meta-signing-key user-key-store.bbclass
# INHERIT += "user-key-store"
# DISTRO_FEATURES:append = " efi-secure-boot"
# keys sample, user
# SIGNING_MODEL = "user"
# MOK_SB ?= "1"
# UEFI_SB ?= "1"
# UEFI_SELOADER ?= "1"
# GRUB_SIGN_VERIFY ?= "0"
# USER_KEY_SHOW_VERBOSE ?= "1"
# SYSTEM_TRUSTED_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/system_trusted_keys"
# SECONDARY_TRUSTED_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/secondary_trusted_keys"
# MODSIGN_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/modsign_keys"
# IMA_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/ima_keys"
# RPM_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/rpm_keys"
# BOOT_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/boot_keys"
# UEFI_SB_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/uefi_sb_keys"
# MOK_SB_KEYS_DIR ?= "${TOPDIR}/../../layers/meta-signing-key/files/mok_sb_keys"
# RPM_GPG_NAME ?= "SecureCore"
# BOOT_GPG_NAME ?= "SecureBootCore"
# BOOT_GPG_PASSPHRASE ?= ""

# repo manifest references
REPO_MANIFEST_URL ?= "ENVIRONMENT-UNSET"
REPO_MANIFEST_BRANCH ?= "ENVIRONMENT-UNSET"
REPO_MANIFEST_FILE ?= "ENVIRONMENT-UNSET"
REPO_MANIFEST_XML ?= "ENVIRONMENT-UNSET"

# ---
