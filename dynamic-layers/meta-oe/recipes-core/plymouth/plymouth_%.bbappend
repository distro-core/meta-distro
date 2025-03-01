PACKAGECONFIG = "initrd freetype pango udev ${PLYMOUTH_THEMES} ${@bb.utils.filter('DISTRO_FEATURES', 'systemd', d)}"
