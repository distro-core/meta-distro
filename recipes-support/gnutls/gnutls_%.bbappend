INSANE_SKIP:${PN}-ptest += "build-deps file-rdeps"

PACKAGECONFIG:append = " tpm2"

PACKAGECONFIG[tpm2] = "--with-tpm2,--without-tpm2,tpm2-tss"
