FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# decrease resource use
# PARALLEL_MAKE = "-j4"

# serialize to reduce compute resource competition on WSL2; this
# causes a dependency during the compilation phase of recipes that
# are resource heavy to bitbake serialized

# do_compile[depends] += "gcc:do_compile"
