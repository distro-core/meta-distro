# Supplied by build

menuentry "Sample EFI boot" --unrestricted {
    savedefault
    set fallback=1
    search --no-floppy --label --set=root boot
    linux /bzImage root=LABEL=root ro rootwait @APPEND@ @OSTREE_KERNEL_ARGS@
    initrd /initrd
}
