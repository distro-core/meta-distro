# variables are derived from a git repo in its layer.conf

do_install:append() {
  if [ -n "${BUILD_COMMIT_DATE}" ] ; then
    echo BUILD_COMMIT_DATE=\"${BUILD_COMMIT_DATE}\" >>${D}${nonarch_libdir}/os-release
  fi
  if [ -n "${BUILD_COMMIT_REF}" ] ; then
    echo BUILD_COMMIT_REF=\"${BUILD_COMMIT_REF}\" >>${D}${nonarch_libdir}/os-release
  fi
  if [ -n "${BUILD_COMMIT_AUTHOR}" ] ; then
    echo BUILD_COMMIT_AUTHOR=\"${BUILD_COMMIT_AUTHOR}\" >>${D}${nonarch_libdir}/os-release
  fi
}
