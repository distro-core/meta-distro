# File: image_types_extend.bbclass
# SPDX-License-Identifier: MIT

# extra image types
# IMAGE_CLASSES += "image_types_extend"

# HOMEPAGE https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro

IMAGE_WSL_EXCLUDES = ""
IMAGE_WSL_EXCLUDES:machineoverride = "--exclude=./boot --exclude=./efi --exclude=./usr/lib/modules --exclude=./usr/share/factory/boot --exclude=./usr/share/factory/efi"

IMAGE_CMD:wsl = "${IMAGE_CMD_TAR} --sort=name --format=posix --numeric-owner ${IMAGE_WSL_EXCLUDES} -c -C ${IMAGE_ROOTFS} . | gzip --best > ${IMGDEPLOYDIR}/${IMAGE_NAME}.wsl || [ $? -eq 1 ]"

# ---
