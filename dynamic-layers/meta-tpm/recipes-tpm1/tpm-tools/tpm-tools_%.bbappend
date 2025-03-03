FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://getpass.c"

do_configure:prepend() {
  cat ${WORKDIR}/getpass.c >> ${S}/lib/tpm_utils.c
}
