# conf/machine/include/machine-providers.inc

# Used to pin specific packages and versions

# meta-intel providers
# PREFERRED_PROVIDER_virtual/kernel:intel-x86-common = "linux-intel"
# PREFERRED_VERSION_linux-intel = "6.8%"
# PREFERRED_VERSION_linux-intel-rt = "6.8%"

# meta-raspberrypi providers
# PREFERRED_PROVIDER_virtual/kernel:raspberrypi5 = "linux-raspberrypi"
# PREFERRED_VERSION_linux-raspberrypi:raspberrypi5 = "6.6%"
# PREFERRED_PROVIDER_virtual/xserver:raspberrypi5 ?= "xserver-xorg"
PREFERRED_PROVIDER_virtual/egl:raspberrypi5 ?= "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'mesa', 'userland', d)}"
PREFERRED_PROVIDER_virtual/libgles2:raspberrypi5 ?= "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'mesa', 'userland', d)}"
PREFERRED_PROVIDER_virtual/libgl:raspberrypi5 ?= "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'mesa', 'mesa-gl', d)}"
PREFERRED_PROVIDER_virtual/mesa:raspberrypi5 ?= "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'mesa', 'mesa-gl', d)}"
PREFERRED_PROVIDER_virtual/libgbm:raspberrypi5 ?= "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'mesa', 'mesa-gl', d)}"
PREFERRED_PROVIDER_vlc:raspberrypi5 ?= "rpidistro-vlc"
PREFERRED_PROVIDER_ffmpeg:raspberrypi5 ?= "rpidistro-ffmpeg"
PREFERRED_PROVIDER_libav:raspberrypi5 ?= "rpidistro-ffmpeg"
PREFERRED_PROVIDER_libpostproc:raspberrypi5 ?= "rpidistro-ffmpeg"
PREFERRED_PROVIDER_jpeg:raspberrypi5 ?= "jpeg"
PREFERRED_PROVIDER_virtual/libomxil:raspberrypi5 ?= "userland"
PREFERRED_PROVIDER_u-boot-default-script:raspberrypi5 ??= "rpi-u-boot-scr"

# meta-riscv providers
# PREFERRED_PROVIDER_virtual/kernel:sbc-pine64-star64 = "linux-raspberrypi"
RDEPENDS:packagegroup-distro-core:remove:sbc-pine64-star64 = "dmidecode"

# meta-tegra providers
# PREFERRED_PROVIDER_virtual/kernel:tegra = "linux-tegra"

# poky
# PREFERRED_PROVIDER_virtual/kernel:wsl-qemuxarm64 = "linux-yocto"
# PREFERRED_PROVIDER_virtual/kernel:wsl-qemux86-64 = "linux-yocto"

# ---
