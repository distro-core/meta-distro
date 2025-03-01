PACKAGECONFIG += "${@bb.utils.filter('DISTRO_FEATURES', 'systemd', d)}"
