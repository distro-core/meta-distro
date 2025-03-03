LDLIBS = "-ltspi -lcrypto"

DEPENDS:append:libc-musl = " argp-standalone"
LDLIBS:append:libc-musl = " -largp"

do_compile() {
    oe_runmake -C ${S}/src LDLIBS="${LDLIBS}"
}
