# extra image types
# IMAGE_CLASSES += "image_types_extend"

# HOMEPAGE https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro
# $ tar --numeric-owner --absolute-names -c  * | gzip --best > ../install.tar.gz

IMAGE_CMD_TAR ?= "tar"
# ignore return code 1 "file changed as we read it" as other tasks(e.g. do_image_wic) may be hardlinking rootfs
IMAGE_CMD:wsl = "${IMAGE_CMD_TAR} --sort=name --format=posix --numeric-owner ${EXTRA_IMAGECMD} -c -C ${IMAGE_ROOTFS} . | gzip --best > ${IMGDEPLOYDIR}/${IMAGE_NAME}.wsl || [ $? -eq 1 ]"

# ---
