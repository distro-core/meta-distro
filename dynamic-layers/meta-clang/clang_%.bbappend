# serialize building (avoid OOM with limited resources)
do_compile[depends] += "cargo-native:do_populate_sysroot"
do_compile[depends] += "rust-native:do_populate_sysroot"
