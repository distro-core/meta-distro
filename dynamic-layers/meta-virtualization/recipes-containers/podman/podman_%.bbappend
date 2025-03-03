FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

SRC_URI += " \
file://check-config.sh \
file://profile.sh \
file://socket.conf \
file://sudoers \
file://systemd \
file://tmpfiles.conf \
"

PACKAGECONFIG += "docker rootless"

do_install:append() {

    install -d -m 0755 -o root -g docker ${D}${localstatedir}/lib/docker

    install -D -m 0755 ${WORKDIR}/check-config.sh ${D}${bindir}/check-config.sh

    install -D -m 0644 ${WORKDIR}/profile.sh ${D}${sysconfdir}/profile.d/00-${PN}.sh
    install -D -m 0644 ${WORKDIR}/socket.conf ${D}${sysconfdir}/systemd/system/${PN}.socket.d/00-${PN}.conf
    install -D -m 0600 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}-sudoers
    install -D -m 0644 ${WORKDIR}/tmpfiles.conf ${D}${sysconfdir}/tmpfiles.d/00-${PN}.conf

    install -m 0644 -t ${D}${systemd_system_unitdir} ${WORKDIR}/systemd/*

    ln -sfr ${D}${systemd_system_unitdir}/${PN}.socket ${D}${systemd_system_unitdir}/docker.socket
    ln -sfr ${D}${systemd_system_unitdir}/${PN}.service ${D}${systemd_system_unitdir}/docker.service

    touch ${S}/linger
    install -D -m 0644 ${S}/linger ${D}${localstatedir}/lib/systemd/linger/docker
}

# incompatible with libc-musl
RDEPENDS:${PN}:remove:libc-musl = "skopeo"
RDEPENDS:${PN}-ptest:remove:libc-musl = "buildah"

FILES:${PN} += "${bindir}/ ${sysconfdir}/ ${localstatedir}/ ${systemd_system_unitdir}/"

inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} += "-U -M docker ;"
