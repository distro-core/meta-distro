FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

SRC_URI:append = " \
file://mosquitto.conf \
file://mosquitto.service \
file://conf.d \
file://aclfile \
file://pwfile \
"

PACKAGECONFIG += "websockets ssl"

inherit useradd

USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM:${PN} = "-r mosquitto ;"
USERADD_PARAM:${PN} = "-p '*' -r -M -d ${localstatedir}/lib/mosquitto -s /bin/false -g mosquitto mosquitto ;"

do_install:append () {

    install -D -m 0644 ${WORKDIR}/mosquitto.conf ${D}${sysconfdir}/mosquitto/mosquitto.conf
    install -D -m 0644 ${WORKDIR}/mosquitto.service ${D}${systemd_system_unitdir}/mosquitto.service

    # base config
    install -d -m 0775 -o root -g mosquitto ${D}${sysconfdir}/mosquitto/conf.d
    install -d -m 0775 -o mosquitto -g mosquitto ${D}${localstatedir}/lib/mosquitto
    install -d -m 0775 -o mosquitto -g mosquitto ${D}${localstatedir}/lib/mosquitto/websocket

    # Permissions 0640 as conf files may contain secrets
    install -D -m 0664 -g mosquitto ${WORKDIR}/aclfile ${D}${sysconfdir}/mosquitto/aclfile
    install -D -m 0640 -o mosquitto -g mosquitto ${WORKDIR}/pwfile ${D}${sysconfdir}/mosquitto/pwfile
    install -D -m 0640 -o mosquitto -g mosquitto ${WORKDIR}/conf.d/listener-sock.conf ${D}${sysconfdir}/mosquitto/conf.d/10-listener-sock.conf
    install -D -m 0640 -o mosquitto -g mosquitto ${WORKDIR}/conf.d/listener-1883.conf ${D}${sysconfdir}/mosquitto/conf.d/20-listener-1883.conf
    install -D -m 0640 -o mosquitto -g mosquitto ${WORKDIR}/conf.d/listener-8883.conf ${D}${sysconfdir}/mosquitto/conf.d/20-listener-8883.conf
    install -D -m 0640 -o mosquitto -g mosquitto ${WORKDIR}/conf.d/listener-9001.conf ${D}${sysconfdir}/mosquitto/conf.d/20-listener-9001.conf

    touch ${S}/mosquitto.db
    install -D -m 0640 -o mosquitto -g mosquitto ${S}/mosquitto.db ${D}${localstatedir}/lib/mosquitto/mosquitto.db

    # random passwords
    # mosquitto_passwd -H sha512 -b ${D}${sysconfdir}/mosquitto/pwfile daemon "$(openssl rand 1024 | head -1)"
    # mosquitto_passwd -H sha512 -b ${D}${sysconfdir}/mosquitto/pwfile application "$(openssl rand 1024 | head -1)"
}

FILES:${PN}:append = " ${sysconfdir}/ ${localstatedir}/ ${systemd_system_unitdir}/"

BBCLASSEXTEND = "native"
