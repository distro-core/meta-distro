# serialize building (avoid OOM with limited resources)
# do_compile[depends] += "virtual/kernel:do_populate_sysroot"
# do_compile[depends] += "mozjs-115:do_populate_sysroot"
# do_compile[depends] += "samba:do_populate_sysroot"
# do_compile[depends] += "ovmf-native:do_populate_sysroot"
BB_NUMBER_THREADS = "${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"
PARALLEL_MAKE = "-j ${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"

PACKAGECONFIG = " \
${@bb.utils.filter('DISTRO_FEATURES', 'systemd wayland x11', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'webgl opengl', '', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'x11', '', 'webgl gles2', d)} \
${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'opengl-or-es', '', d)} \
enchant \
libsecret \
soup3 \
reduce-size \
"

DEPENDS += "libsecret"
RDEPENDS:${PN} += "libsecret"

DEPENDS:append:tegra = " ruby-native unifdef-native gperf-native libtasn1 libwebp gtk4 libsoup libxslt egl-gbm"
RDEPENDS:${PN}:append:tegra = " libtasn1 libwebp gtk4 libsoup libxslt egl-gbm"
