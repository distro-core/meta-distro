do_rootfs[depends] += " virtual/kernel:do_shared_workdir"

rootfs_flatten_kernel_modules() {
    export KERNEL_VERSION="${@oe.utils.read_file("${STAGING_KERNEL_BUILDDIR}/kernel-abiversion")}"
    [ -n "${KERNEL_VERSION}" ]
    if [ -d "${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}" ]; then
        cd ${IMAGE_ROOTFS} && find lib/modules/${KERNEL_VERSION} -name "*.ko" -exec sh -c 'mod="{}"; ln -sf /$mod ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/$(basename "$mod")' \;
    fi
}

ROOTFS_POSTUNINSTALL_COMMAND:append = " rootfs_flatten_kernel_modules;"
