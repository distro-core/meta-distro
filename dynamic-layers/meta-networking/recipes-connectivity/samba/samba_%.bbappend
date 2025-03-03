# serialize building (avoid OOM with limited resources)
do_compile[depends] += "virtual/kernel:do_populate_sysroot"
do_compile[depends] += "webkitgtk:do_populate_sysroot"
do_compile[depends] += "webkitgtk3:do_populate_sysroot"
