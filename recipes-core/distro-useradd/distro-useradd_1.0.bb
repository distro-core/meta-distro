FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SUMMARY = "Add users and groups"
DESCRIPTION = "Add customized users and groups with common home folder content."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# DO NOT STORE CLEAR TEXT PASSWORDS IN THIS RECIPE OR COMMIT TO VERSION CONTROL

# PASSWORD is generated with the command 'openssl passwd -6' and then captured to this
# recipe. It is necessary to escape the '$' within the generated output, and there should
# be 3 patterns to set the escape on. $6$<salt>$<hash> -> \\\$6\\\$<salt>\\\$<hash> The shell
# quoted chars are to insure that the password hash is used without variable expansion by the
# shell "\\ = \", "\$ = $" such that the quoted string can be used.

# Generate a password, copy & paste to shell prompt
# openssl passwd -6 | sed -e 's/\$/\\\\\\\$/g'

# Generate a random 512bit password (repeat until only 1 hash is output)
# openssl rand -out - 64 | openssl passwd -in - -6 | sed -e 's/\$/\\\\\\\$/g'

DEPENDS = "openssl-native"

SRC_URI = " \
file://sudoers \
file://hushlogin \
file://ssh_config \
"

# RCONFLICTS:${PN} = "other-useradd"

SHELL_SH = "-s /bin/sh"
SHELL_RSH = "-s /bin/rsh"

inherit useradd extrausers

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = ""

USERADD_PARAM:${PN} = ""

do_install() {
    install -d ${D}${base_bindir}
    ln -sfr ${D}${base_bindir}/sh ${D}${base_bindir}/rsh
    install -D -m 0600 ${WORKDIR}/sudoers ${D}${sysconfdir}/sudoers.d/00-${PN}-sudoers

    for user in admin user; do
        install -d -m 0750 -o $user -g $user ${D}/home/$user
        install -d -m 0750 -o $user -g $user ${D}/home/$user/.config
        install -d -m 0700 -o $user -g $user ${D}/home/$user/.gnupg
        install -d -m 0750 -o $user -g $user ${D}/home/$user/.local
        install -d -m 0750 -o $user -g $user ${D}/home/$user/.local/bin
        install -d -m 0700 -o $user -g $user ${D}/home/$user/.ssh
        install -D -m 0750 -o $user -g $user ${WORKDIR}/ssh_config ${D}/home/$user/.ssh/config
        install -D -m 0750 -o $user -g $user ${WORKDIR}/hushlogin ${D}/home/$user/.hushlogin
        # touch ${S}/linger
        # install -D -m 0644 ${S}/linger ${D}${localstatedir}/lib/systemd/linger/$user
    done

    install -d -m 0700 -o root -g root ${D}/root
    install -d -m 0750 -o root -g root ${D}/root/.config
    install -d -m 0700 -o root -g root ${D}/root/.gnupg
    install -d -m 0750 -o root -g root ${D}/root/.local
    install -d -m 0750 -o root -g root ${D}/root/.local/bin
    install -d -m 0700 -o root -g root ${D}/root/.ssh
    install -D -m 0750 -o root -g root ${WORKDIR}/ssh_config ${D}/root/.ssh/config
    install -D -m 0750 -o root -g root ${WORKDIR}/hushlogin ${D}/root/.hushlogin

    # touch ${S}/linger
    # install -D -m 0644 ${S}/linger ${D}${localstatedir}/lib/systemd/linger/docker
}

FILES:${PN} = "${base_bindir}/rsh ${sysconfdir}/sudoers.d/00-${PN}-sudoers /root/ ${localstatedir}/lib/systemd/linger/root"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

####################

# existing users require usermod
# EXTRA_USERS_PARAMS = "usermod -M -d /root root ;"

####################

USERADD_PARAM:${PN} += "-U -M docker ;"
FILES:${PN} += "/home/docker ${localstatedir}/lib/systemd/linger/docker"

# explicit account lockout
USERADD_PARAM:${PN} += "-p '*' docker ;"
USERADD_PARAM:${PN} += "-p '*' mosquitto ;"
USERADD_PARAM:${PN} += "-p '*' tss ;"
USERADD_PARAM:${PN} += "-p '*' messagebus ;"
USERADD_PARAM:${PN} += "-p '*' rpc ;"
USERADD_PARAM:${PN} += "-p '*' systemd-timesync ;"
USERADD_PARAM:${PN} += "-p '*' systemd-resolve ;"
USERADD_PARAM:${PN} += "-p '*' systemd-network ;"

# add entries to shadow:subuid shadow:subgid as needed

####################

USERADD_PARAM:${PN}-admin = " -p '*' -U -M -d /home/admin ${SHELL_SH} admin"
USERADD_PACKAGES += "${PN}-admin"
ALLOW_EMPTY:${PN}-admin = "1"
PACKAGES += "${PN}-admin"
FILES:${PN}-admin = "/home/admin/ ${localstatedir}/lib/systemd/linger/admin"
RDEPENDS:${PN}-admin = "${PN}"

####################

USERADD_PARAM:${PN}-user = " -p '*' -U -M -d /home/user ${SHELL_RSH} user"
USERADD_PACKAGES += "${PN}-user"
ALLOW_EMPTY:${PN}-user = "1"
PACKAGES += "${PN}-user"
FILES:${PN}-user = "/home/user/ ${localstatedir}/lib/systemd/linger/user"
RDEPENDS:${PN}-user = "${PN}"
