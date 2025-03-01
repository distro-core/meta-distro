# serialize building (avoid OOM with limited resources)
# do_compile[depends] += "${PREFERRED_PROVIDER_virtual/kernel}:do_populate_sysroot"
BB_NUMBER_THREADS = "${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"
# PARALLEL_MAKE = "-j ${@ 2 if oe.utils.cpu_count() <= 2 else int(oe.utils.cpu_count() / 2)}"
