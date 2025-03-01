FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://getpass.c"

do_configure:prepend() {
  install -D ${WORKDIR}/getpass.c ${S}/lib/getpass.C
  sed -i -e 's/tpm_utils.c/tpm_utils.c getpass.c/g' ${S}/lib/Makefile.am
}
