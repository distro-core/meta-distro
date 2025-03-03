FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://init.cryptfs"

do_install:append() {
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'luks', '1', '0', d)}" = "1" ]; then
        install -m 0500 "${WORKDIR}/init.cryptfs" "${D}"
    fi
}
