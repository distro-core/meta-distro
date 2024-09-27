# serialize building (avoid OOM)
# PARALLEL_MAKE= "-j${@int(os.cpu_count() * 70 / 100 )}"
# do_compile[depends] += "${PREFERRED_PROVIDER_virtual/kernel}:do_populate_sysroot"
