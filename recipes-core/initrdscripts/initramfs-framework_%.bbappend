FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Note: required kernel modules must be build-in for the kernel; initramfs
# has build time dependency issues when attempting to include a kernel module.

inherit image_types_partition

do_install:append() {

    cat >${S}/image_types_partition <<_EOF_

GPT_DISK_UUID="${GPT_DISK_UUID}"

GPT_PART_NAME_ESP="${GPT_PART_NAME_ESP}"
GPT_PART_UUID_ESP="${GPT_PART_UUID_ESP}"
GPT_PART_TYPE_ESP="${GPT_PART_TYPE_ESP}"
FSYS_DEV_NAME_ESP="${FSYS_DEV_NAME_ESP}"
FSYS_DEV_UUID_ESP="${FSYS_DEV_UUID_ESP}"
FSYS_DEV_TYPE_ESP="${FSYS_DEV_TYPE_ESP}"
FSYS_DEV_UUID_ESP_FSTAB="${FSYS_DEV_UUID_ESP_FSTAB}"

GPT_PART_NAME_XBOOTLDR="${GPT_PART_NAME_XBOOTLDR}"
GPT_PART_UUID_XBOOTLDR="${GPT_PART_UUID_XBOOTLDR}"
GPT_PART_TYPE_XBOOTLDR="${GPT_PART_TYPE_XBOOTLDR}"
FSYS_DEV_NAME_XBOOTLDR="${FSYS_DEV_NAME_XBOOTLDR}"
FSYS_DEV_UUID_XBOOTLDR="${FSYS_DEV_UUID_XBOOTLDR}"
FSYS_DEV_TYPE_XBOOTLDR="${FSYS_DEV_TYPE_XBOOTLDR}"

GPT_PART_NAME_VERITY="${GPT_PART_NAME_VERITY}"
GPT_PART_UUID_VERITY="${GPT_PART_UUID_VERITY}"
GPT_PART_TYPE_VERITY="${GPT_PART_TYPE_VERITY}"

GPT_PART_NAME_ROOT="${GPT_PART_NAME_ROOT}"
GPT_PART_UUID_ROOT="${GPT_PART_UUID_ROOT}"
GPT_PART_TYPE_ROOT="${GPT_PART_TYPE_ROOT}"
FSYS_DEV_NAME_ROOT="${FSYS_DEV_NAME_ROOT}"
FSYS_DEV_UUID_ROOT="${FSYS_DEV_UUID_ROOT}"
FSYS_DEV_TYPE_ROOT="${FSYS_DEV_TYPE_ROOT}"

GPT_PART_NAME_USRVERITY="${GPT_PART_NAME_USRVERITY}"
GPT_PART_UUID_USRVERITY="${GPT_PART_UUID_USRVERITY}"
GPT_PART_TYPE_USRVERITY="${GPT_PART_TYPE_USRVERITY}"

GPT_PART_NAME_USR="${GPT_PART_NAME_USR}"
GPT_PART_UUID_USR="${GPT_PART_UUID_USR}"
GPT_PART_TYPE_USR="${GPT_PART_TYPE_USR}"
FSYS_DEV_NAME_USR="${FSYS_DEV_NAME_USR}"
FSYS_DEV_UUID_USR="${FSYS_DEV_UUID_USR}"
FSYS_DEV_TYPE_USR="${FSYS_DEV_TYPE_USR}"

GPT_PART_NAME_HOME="${GPT_PART_NAME_HOME}"
GPT_PART_UUID_HOME="${GPT_PART_UUID_HOME}"
GPT_PART_TYPE_HOME="${GPT_PART_TYPE_HOME}"
FSYS_DEV_NAME_HOME="${FSYS_DEV_NAME_HOME}"
FSYS_DEV_UUID_HOME="${FSYS_DEV_UUID_HOME}"
FSYS_DEV_TYPE_HOME="${FSYS_DEV_TYPE_HOME}"

GPT_PART_NAME_SRV="${GPT_PART_NAME_SRV}"
GPT_PART_UUID_SRV="${GPT_PART_UUID_SRV}"
GPT_PART_TYPE_SRV="${GPT_PART_TYPE_SRV}"
FSYS_DEV_NAME_SRV="${FSYS_DEV_NAME_SRV}"
FSYS_DEV_UUID_SRV="${FSYS_DEV_UUID_SRV}"
FSYS_DEV_TYPE_SRV="${FSYS_DEV_TYPE_SRV}"

GPT_PART_NAME_USER="${GPT_PART_NAME_USER}"
GPT_PART_UUID_USER="${GPT_PART_UUID_USER}"
GPT_PART_TYPE_USER="${GPT_PART_TYPE_USER}"
FSYS_DEV_NAME_USER="${FSYS_DEV_NAME_USER}"
FSYS_DEV_UUID_USER="${FSYS_DEV_UUID_USER}"
FSYS_DEV_TYPE_USER="${FSYS_DEV_TYPE_USER}"

GPT_PART_NAME_SWAP="${GPT_PART_NAME_SWAP}"
GPT_PART_UUID_SWAP="${GPT_PART_UUID_SWAP}"
GPT_PART_TYPE_SWAP="${GPT_PART_TYPE_SWAP}"
FSYS_DEV_UUID_SWAP="${FSYS_DEV_UUID_SWAP}"
FSYS_DEV_TYPE_SWAP="${FSYS_DEV_TYPE_SWAP}"

GPT_PART_NAME_VAR="${GPT_PART_NAME_VAR}"
GPT_PART_UUID_VAR="${GPT_PART_UUID_VAR}"
GPT_PART_TYPE_VAR="${GPT_PART_TYPE_VAR}"
FSYS_DEV_NAME_VAR="${FSYS_DEV_NAME_VAR}"
FSYS_DEV_UUID_VAR="${FSYS_DEV_UUID_VAR}"
FSYS_DEV_TYPE_VAR="${FSYS_DEV_TYPE_VAR}"

GPT_PART_NAME_LIB="${GPT_PART_NAME_LIB}"
GPT_PART_UUID_LIB="${GPT_PART_UUID_LIB}"
GPT_PART_TYPE_LIB="${GPT_PART_TYPE_LIB}"
FSYS_DEV_NAME_LIB="${FSYS_DEV_NAME_LIB}"
FSYS_DEV_UUID_LIB="${FSYS_DEV_UUID_LIB}"
FSYS_DEV_TYPE_LIB="${FSYS_DEV_TYPE_LIB}"

GPT_PART_NAME_LOG="${GPT_PART_NAME_LOG}"
GPT_PART_UUID_LOG="${GPT_PART_UUID_LOG}"
GPT_PART_TYPE_LOG="${GPT_PART_TYPE_LOG}"
FSYS_DEV_NAME_LOG="${FSYS_DEV_NAME_LOG}"
FSYS_DEV_UUID_LOG="${FSYS_DEV_UUID_LOG}"
FSYS_DEV_TYPE_LOG="${FSYS_DEV_TYPE_LOG}"

GPT_PART_NAME_AUDIT="${GPT_PART_NAME_AUDIT}"
GPT_PART_UUID_AUDIT="${GPT_PART_UUID_AUDIT}"
GPT_PART_TYPE_AUDIT="${GPT_PART_TYPE_AUDIT}"
FSYS_DEV_NAME_AUDIT="${FSYS_DEV_NAME_AUDIT}"
FSYS_DEV_UUID_AUDIT="${FSYS_DEV_UUID_AUDIT}"
FSYS_DEV_TYPE_AUDIT="${FSYS_DEV_TYPE_AUDIT}"

GPT_PART_NAME_TMP="${GPT_PART_NAME_TMP}"
GPT_PART_UUID_TMP="${GPT_PART_UUID_TMP}"
GPT_PART_TYPE_TMP="${GPT_PART_TYPE_TMP}"
FSYS_DEV_NAME_TMP="${FSYS_DEV_NAME_TMP}"
FSYS_DEV_UUID_TMP="${FSYS_DEV_UUID_TMP}"
FSYS_DEV_TYPE_TMP="${FSYS_DEV_TYPE_TMP}"

GPT_PART_NAME_DATA="${GPT_PART_NAME_DATA}"
GPT_PART_UUID_DATA="${GPT_PART_UUID_DATA}"
GPT_PART_TYPE_DATA="${GPT_PART_TYPE_DATA}"

GPT_PART_NAME_LUKS="${GPT_PART_NAME_LUKS}"
GPT_PART_UUID_LUKS="${GPT_PART_UUID_LUKS}"
GPT_PART_TYPE_LUKS="${GPT_PART_TYPE_LUKS}"
FSYS_DEV_NAME_LUKS="${FSYS_DEV_NAME_LUKS}"
FSYS_DEV_UUID_LUKS="${FSYS_DEV_UUID_LUKS}"
FSYS_DEV_TYPE_LUKS="${FSYS_DEV_TYPE_LUKS}"

GPT_PART_NAME_LVM="${GPT_PART_NAME_LVM}"
GPT_PART_UUID_LVM="${GPT_PART_UUID_LVM}"
GPT_PART_TYPE_LVM="${GPT_PART_TYPE_LVM}"

_EOF_

    install -D -m 0755 ${S}/image_types_partition ${D}/init.d/image_types_partition
}

FILES:${PN}-base += "/init.d/image_types_partition"

inherit deploy
do_deploy() {
    install -D -m 0755 ${S}/image_types_partition ${DEPLOYDIR}/image_types_partition
}
addtask deploy after do_install before do_package