# serialize building (avoid OOM with limited resources)
# do_compile[depends] += "cargo-native:do_populate_sysroot"
# do_compile[depends] += "llvm-native:do_populate_sysroot"
# do_compile[depends] += "rust-native:do_populate_sysroot"
# do_compile[depends] += "rust-llvm-native:do_populate_sysroot"
BB_NUMBER_THREADS = "${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"
PARALLEL_MAKE = "-j ${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"
