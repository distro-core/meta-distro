SUMMARY = "Script for growing a partition"
DESCRIPTION = "\
This package provides the growpart script for growing a partition. It is \
primarily used in cloud images in conjunction with the dracut-modules-growroot \
package to grow the root partition on first boot. \
"
HOMEPAGE = "https://launchpad.net/cloud-utils"
LICENSE = "GPL-3.0-only"

LIC_FILES_CHKSUM = "file://LICENSE;md5=d32239bcb673463ab874e80d47fae504"

SRC_URI = "https://launchpad.net/cloud-utils/trunk/${PV}/+download/cloud-utils-${PV}.tar.gz;name=cloud-utils"

SRC_URI[cloud-utils.md5sum] = "9b256ff2dbfabaaaf2298d0052eaa5ae"
SRC_URI[cloud-utils.sha256sum] = "132255cbda774834695e2912e09b9058d3281a94874be57e48f2f04f4b89ad77"

S = "${WORKDIR}/cloud-utils-${PV}"

ROOT_DISK ??= "/dev/sda"
ROOT_PARTITION ??= "2"

inherit systemd

RDEPENDS_${PN} = " \
    gawk \
    util-linux \
"

FILES:${PN} = "${bindir}/ ${systemd_system_unitdir}/"

SYSTEMD_AUTO_ENABLE = "disable"

SYSTEMD:${PN} = "growpart.service"

do_install() {
    cat <<EOF >${S}/growpart.service
[Unit]
Description=Extend root partition and resize ext4 file system
After=local-fs.target
Wants=local-fs.target

[Service]
Environment=ROOT_DISK=${ROOT_DISK}
Environment=ROOT_PARTITION=${ROOT_PARTITION}
ExecStart=${bindir}/sh -c "${bindir}/growpart -N \${ROOT_DISK} \${ROOT_PARTITION} && ${bindir}/growpart \${ROOT_DISK} \${ROOT_PARTITION} || exit 0"
ExecStop=${bindir}/sh -c "${sbindir}/resize2fs \${ROOT_DISK}\${ROOT_PARTITION} || exit 0"
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

    cat <<EOF >${S}/resize-part-image.service
[Unit]
Description=Extend root partition and resize ext4 file system
After=local-fs.target
Wants=local-fs.target

[Service]
Environment=ROOT_DISK=${ROOT_DISK}
Environment=ROOT_PARTITION=${ROOT_PARTITION}
ExecStart=${bindir}/sh -c "${bindir}/resize-part-image -N \${ROOT_DISK} \${ROOT_PARTITION} && ${bindir}/growpart \${ROOT_DISK} \${ROOT_PARTITION} || exit 0"
ExecStop=${bindir}/sh -c "${sbindir}/resize2fs \${ROOT_DISK}\${ROOT_PARTITION} || exit 0"
Type=oneshot

[Install]
WantedBy=multi-user.target
EOD

    install -D -m 0755 ${S}/bin/growpart ${D}${bindir}/growpart
    install -D -m 0755 ${S}/bin/resize-part-image ${D}${bindir}/resize-part-image
    install -D -m 0644 ${S}/growpart.service ${D}${systemd_system_unitdir}/growpart.service
    install -D -m 0644 ${S}/resize-part-image.service ${D}${systemd_system_unitdir}/resize-part-image.service
}
