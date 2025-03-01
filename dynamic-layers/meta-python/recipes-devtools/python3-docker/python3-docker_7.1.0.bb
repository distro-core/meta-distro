
SUMMARY = "Python client for Docker"
DESCRIPTION = "A Python library for the Docker Engine API."
HOMEPAGE = "https://github.com/docker/docker-py"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit pypi python_poetry_core python_hatchling

SRC_URI[sha256sum] = "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"

PYPI_PACKAGE = "docker"
UPSTREAM_CHECK_PYPI_PACKAGE = "${PYPI_PACKAGE}"

DEPENDS += "python3-hatch-vcs-native"

RDEPENDS:${PN} += "python3-core ${PREFERRED_PROVIDER_virtual/docker}"

BBCLASSEXTEND = "native nativesdk"
