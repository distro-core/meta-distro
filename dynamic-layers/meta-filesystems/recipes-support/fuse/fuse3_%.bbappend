BBCLASSEXTEND += "native"

DEPENDS = ""

DEPENDS:class-target = "udev"

RDEPENDS:${PN}:class-target += "kernel-module-fuse fuse3-utils"
