# serialize building (avoid OOM)
# PARALLEL_MAKE= "-j${@int(os.cpu_count() * 70 / 100 )}"
do_compile[depends] += "cargo-native:do_populate_sysroot"
do_compile[depends] += "rust-native:do_populate_sysroot"
