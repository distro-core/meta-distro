# serialize building (avoid OOM with limited resources)
do_compile[depends] += "${PREFERRED_PROVIDER_virtual/kernel}:do_populate_sysroot"
