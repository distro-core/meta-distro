# conf/distro/include/distro-mingw.inc

SDK_ARCH = "x86_64"
TESTSDK_WINEARCH = "win64"

require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'meta-mingw', 'conf/machine-sdk/include/mingw32-common.inc', '', d)}

# ---
