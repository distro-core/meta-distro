# variables are derived from a git repo in its layer.conf

do_install:append() {
  if [ -n "${MACHINE}" ] ; then
    echo MACHINE=\"${MACHINE}\" >>${D}${nonarch_libdir}/os-release
  fi
  if [ -n "${BUILD_COMMIT_DATE}" ] ; then
    echo BUILD_COMMIT_DATE=\"${BUILD_COMMIT_DATE}\" >>${D}${nonarch_libdir}/os-release
  fi
  if [ -n "${BUILD_COMMIT_REF}" ] ; then
    echo BUILD_COMMIT_REF=\"${BUILD_COMMIT_REF}\" >>${D}${nonarch_libdir}/os-release
  fi
  # if [ -n "${BUILD_COMMIT_AUTHOR}" ] ; then
  #   echo BUILD_COMMIT_AUTHOR=\"${BUILD_COMMIT_AUTHOR}\" >>${D}${nonarch_libdir}/os-release
  # fi
  if [ -n "${REPO_MANIFEST_URL}" ] ; then
    echo REPO_MANIFEST_URL=\"${REPO_MANIFEST_URL}\" >>${D}${nonarch_libdir}/os-release
  fi
  if [ -n "${REPO_MANIFEST_REF}" ] ; then
    echo REPO_MANIFEST_REF=\"${REPO_MANIFEST_REF}\" >>${D}${nonarch_libdir}/os-release
  fi
  if [ -n "${REPO_MANIFEST_FILE}" ] ; then
    echo REPO_MANIFEST_FILE=\"${REPO_MANIFEST_FILE}\" >>${D}${nonarch_libdir}/os-release
  fi
}

inherit deploy
do_deploy() {
    install -D -m 0644 ${D}${nonarch_libdir}/os-release ${DEPLOYDIR}/os-release
}
addtask deploy after do_install before do_package
