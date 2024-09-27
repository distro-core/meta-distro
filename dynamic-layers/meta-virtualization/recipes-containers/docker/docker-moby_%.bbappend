FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

SRC_URI += " \
file://daemon.json \
file://check-config.sh \
file://profile.sh \
file://socket.conf \
file://sudoers \
file://systemd \
file://tmpfiles.conf \
"

PACKAGECONFIG += "docker-init seccomp"

do_install:append() {

    # install -d -m 0755 -o root -g docker ${D}${localstatedir}/lib/docker
    # install -d -m 0755 -o root -g docker ${D}${localstatedir}/run/docker

    install -D -m 0755 ${WORKDIR}/check-config.sh ${D}${bindir}/check-config.sh
    install -D -m 0644 ${WORKDIR}/daemon.json ${D}${sysconfdir}/docker/daemon.json
    install -D -m 0644 ${WORKDIR}/profile.sh ${D}${sysconfdir}/profile.d/00-${PN}.sh
    install -D -m 0600 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}-sudoers
    install -D -m 0644 ${WORKDIR}/tmpfiles.conf ${D}${sysconfdir}/tmpfiles.d/00-${PN}.conf

    if [ "${INIT_MANAGER}" = "systemd" ]; then
        install -m 0644 -t ${D}${systemd_system_unitdir} ${WORKDIR}/systemd/*
        install -D -m 0644 ${WORKDIR}/socket.conf ${D}${sysconfdir}/systemd/system/${PN}.socket.d/00-${PN}.conf
        touch ${S}/linger
        install -D -m 0644 ${S}/linger ${D}${localstatedir}/lib/systemd/linger/docker
    fi
}

FILES:${PN} += "${bindir}/ ${sysconfdir}/ ${localstatedir}/ ${systemd_system_unitdir}/"

inherit useradd

USERADD_PACKAGES = "${PN}"

USERADD_PARAM:${PN} = "-p '*' -U docker ; -p '*' -U dockremap"
