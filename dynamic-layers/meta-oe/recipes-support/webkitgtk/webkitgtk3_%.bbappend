# serialize building (avoid OOM)
# PARALLEL_MAKE:class-target = "-j${@int(os.cpu_count() * 0.50)}"
do_compile[depends] += "${PREFERRED_PROVIDER_virtual/kernel}:do_populate_sysroot"
do_compile[depends] += "${@bb.utils.contains('BBFILE_COLLECTIONS', 'clang-layer', 'clang:do_populate_sysroot', '', d)}"
do_compile[depends] += "webkitgtk:do_populate_sysroot"
