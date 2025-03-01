PACKAGECONFIG = "vala mbim qmi \
${@bb.utils.filter('DISTRO_FEATURES', 'systemd polkit', d)} \
"

SYSTEMD_AUTO_ENABLE:${PN} = "disable"
