#!/bin/bash

# Example script to create a virtualbox VM using WSL2 as a new
# Linux Instance. The resulting VM can be utilized as part of
# a development process.

err_exit() {
    if [[ -n "${wsl_wic_path}" ]]; then
        rm -f ${wsl_wic_path}
    fi
}
trap err_exit EXIT

set -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_NAME=$(basename $0)

VALID_ARGS=$(getopt -o hM:T:d:t: --long help,machine:,target:,device:,type: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help)
            echo "Usage: $SCRIPT_NAME [--machine '<machine_list>'] [--target '<target_list>']"
            echo "--machine='<machine_list>'       set machine_list"
            echo "--target='<target_list>'         set target_list"
            # echo "--type 'type'               set type"
            # echo "--crypto 'crypto'           set encrypted"
            # echo "--fstype 'fstype'           set encrypted"
            exit 0
            ;;
        -M | --machine)
            machines=( $2 )
            shift 2
            ;;
        -T | --target)
            targets=( $2 )
            shift 2
            ;;
        -d | --device)
            flash_device=$2
            shift 2
            ;;
        -t | --type)
            flash_type=$2
            shift 2
            ;;
        --) shift
            break
            ;;
    esac
done

# if [[ -z "${distro}" ]]; then
#     distro=distro-core
#     echo "INFO: set default distro to ${distro}"
# fi

if [[ ${#machines[*]} -eq 0 ]]; then
    machines=( sbc-gene-bt05 )
    echo "INFO: set default machines to ${machines[*]}"
fi

machine=${machine[0]}

if [[ ${#targets[*]} -eq 0 ]]; then
    targets=( distro-image distro-sdk-image )
    echo "INFO: set default targets to ${targets[*]}"
fi

target=${targets[0]}

if [[ -z "${flash_device}" ]]; then
    flash_device=/dev/null
fi

if [[ -z "${flash_type}" ]]; then
    flash_type=vbox
fi

WORK_DIR=/mnt/work

# image_types_partition.bbclass

. artifacts/${machine}/images/image_types_partition

sfdisk_device_partition() {

    echo "label: gpt" | sfdisk --quiet $1
    echo ", 63M" | sfdisk --quiet --append $1
    echo ", 1023M" | sfdisk --quiet --append $1
    echo ";" | sfdisk --quiet --append $1

    sfdisk --quiet --part-label $1 1 ${GPT_PART_NAME_ESP}
    sfdisk --quiet --part-type  $1 1 ${GPT_PART_TYPE_ESP}
    sfdisk --quiet --part-uuid  $1 1 ${GPT_PART_UUID_ESP}
    sfdisk --quiet --part-attrs $1 1 "LegacyBIOSBootable"

    sfdisk --quiet --part-label $1 2 ${GPT_PART_NAME_XBOOTLDR}
    sfdisk --quiet --part-type  $1 2 ${GPT_PART_TYPE_XBOOTLDR}
    sfdisk --quiet --part-uuid  $1 2 ${GPT_PART_UUID_XBOOTLDR}
    sfdisk --quiet --part-attrs $1 2 ""

    sfdisk --quiet --part-label $1 3 ${GPT_PART_NAME_ROOT}
    sfdisk --quiet --part-type  $1 3 ${GPT_PART_TYPE_ROOT}
    sfdisk --quiet --part-uuid  $1 3 ${GPT_PART_UUID_ROOT}
    sfdisk --quiet --part-attrs $1 3 ""

    sfdisk --quiet --disk-id $1 ${GPT_DISK_UUID}

    sfdisk --dump $1 | sed -e "s@$1@sda@g"
}

loopdev_device_image() {

    sudo bash -c "
#!/bin/sh

set -ex

err_exit() {
    rm -f \${LUKS_KEYFILE} || true
    umount -f \${work_dev}p3 || true
    umount -f \${work_dev}p2 || true
    umount -f \${work_dev}p1 || true
    losetup --detach \${work_dev}
    if [[ -n "${wsl_wic_path}" ]]; then
        rm -f ${wsl_wic_path}
    fi
}
trap err_exit EXIT

set -o errexit

if [[ -n "$1" ]]; then
    work_dev=$1
else
    work_dev=$(losetup --find --partscan --show $1)
fi
echo work_dev is \${work_dev}

umount ${WORK_DIR} || true
rm -fr ${WORK_DIR}
mkdir -p ${WORK_DIR}

# partition1

mkfs.${FSYS_DEV_TYPE_ESP} -F 32 -n ${FSYS_DEV_NAME_ESP} -i ${FSYS_DEV_UUID_ESP} \${work_dev}p1
mount \${work_dev}p1 ${WORK_DIR}
# systemd-boot
install -D $(pwd)/artifacts/${machine}/images/systemd-bootx64.efi ${WORK_DIR}/EFI/BOOT/bootx64.efi
install -D $(pwd)/artifacts/${machine}/images/systemd-bootx64.efi ${WORK_DIR}/EFI/systemd/systemd-bootx64.efi
# refind-bin
install -D $(pwd)/artifacts/${machine}/images/ext2_x64.efi ${WORK_DIR}/EFI/systemd/drivers/ext2_x64.efi
install -D $(pwd)/artifacts/${machine}/images/ext4_x64.efi ${WORK_DIR}/EFI/systemd/drivers/ext4_x64.efi
install -D $(pwd)/artifacts/${machine}/images/btrfs_x64.efi ${WORK_DIR}/EFI/systemd/drivers/btrfs_x64.efi
# ovmf-shell-efi
# install -D $(pwd)/artifacts/${machine}/images/shellx64.conf ${WORK_DIR}/loader/entries/shellx64.conf
# install -D $(pwd)/artifacts/${machine}/images/shellx64.efi ${WORK_DIR}/shellx64.efi
# install -D $(pwd)/artifacts/${machine}/images/startup.nsh ${WORK_DIR}/startup.nsh
sync
umount ${WORK_DIR}

# partition2

mkfs.${FSYS_DEV_TYPE_XBOOTLDR} -F -i 1024 -L ${FSYS_DEV_NAME_XBOOTLDR} -U ${FSYS_DEV_UUID_XBOOTLDR} \${work_dev}p2
mount \${work_dev}p2 ${WORK_DIR}
sync
umount ${WORK_DIR}

# partition3

LUKS_KEYFILE=$(mktemp -u /tmp/luks-key.XXXXXX)
dd if=/dev/zero of=\${LUKS_KEYFILE} bs=2048 count=1

cryptsetup luksFormat --key-file \${LUKS_KEYFILE} --key-slot 7 --batch-mode --use-random --uuid ${FSYS_DEV_UUID_LUKS} \${work_dev}p3
cryptsetup luksOpen --key-file \${LUKS_KEYFILE} \${work_dev}p3 ${FSYS_DEV_NAME_LUKS}

pvcreate --norestorefile --uuid ${GPT_PART_UUID_LVM} /dev/mapper/${FSYS_DEV_NAME_LUKS}
vgcreate vg0 /dev/mapper/${FSYS_DEV_NAME_LUKS}

lvcreate -L 256M -n ${FSYS_DEV_NAME_AUDIT} vg0
lvcreate -L 512M -n ${FSYS_DEV_NAME_LOG} vg0
lvcreate -l 100%FREE -n ${FSYS_DEV_NAME_ROOT} vg0

mkfs.${FSYS_DEV_TYPE_AUDIT} -F -i 1024 -L ${FSYS_DEV_NAME_AUDIT} -U ${FSYS_DEV_UUID_AUDIT} /dev/mapper/vg0-${FSYS_DEV_NAME_AUDIT}
mkfs.${FSYS_DEV_TYPE_LOG} -F -i 1024 -L ${FSYS_DEV_NAME_LOG} -U ${FSYS_DEV_UUID_LOG} /dev/mapper/vg0-${FSYS_DEV_NAME_LOG}
mkfs.${FSYS_DEV_TYPE_ROOT} -F -i 1024 -L ${FSYS_DEV_NAME_ROOT} -U ${FSYS_DEV_UUID_ROOT} /dev/mapper/vg0-${FSYS_DEV_NAME_ROOT}

mount /dev/mapper/vg0-${FSYS_DEV_NAME_ROOT} ${WORK_DIR}
tar -xf $(realpath $(pwd)/artifacts/${machine}/images/${target}-${machine}.ota.tar.gz) -C ${WORK_DIR} ./

rsync -azh ${WORK_DIR}/boot/ ${WORK_DIR}/boot.bak/
rm -fr ${WORK_DIR}/boot/*

mount \${work_dev}p2 ${WORK_DIR}/boot
rsync -azh ${WORK_DIR}/boot.bak/ ${WORK_DIR}/boot/
rm -fr ${WORK_DIR}/boot.bak

umount -f \${work_dev}p2 ; sync
umount -f \${work_dev}p1 ; sync

vgchange -a n ; sync

cryptsetup luksClose ${FSYS_DEV_NAME_LUKS}

losetup --detach \${work_dev}
"

}

echo "INFO: device ${flash_device} type ${flash_type}"

case ${flash_type} in

vbox)

    VboxVMwin="$(VBoxManage.exe list systemproperties | grep "Default machine folder:" | tr -s '[:blank:]' | cut -d' ' -f4-)"
    VboxVMwin="${VboxVMwin/$'\r'/}"
    VboxVMwsl=$(wslpath "${VboxVMwin}")

    echo "INFO: VboxVMwin ${VboxVMwin}"
    echo "INFO: VboxVMwsl ${VboxVMwsl}"

    wsl_wic_path="$(realpath $(pwd)/${target}-${machine}-$(date -u +%Y%m%d%H%M).raw)"

    vdi_basename="$(basename ${wsl_wic_path} .raw)"

    dd if=/dev/zero of=${wsl_wic_path} bs=1K count=$(( 16 * 1048576 )) status=progress

    sfdisk_device_partition ${wsl_wic_path}

    loopdev_device_image ${wsl_wic_path}

    VBoxManage.exe controlvm ${machine} poweroff && sleep 10 || true

    VBoxManage.exe unregistervm ${machine} --delete && rm -fr "${VboxVMwsl}/${machine}" || true

    VBoxManage.exe createvm --name ${machine} --register --ostype Linux_64 --default

    VBoxManage.exe modifyvm ${machine} --paravirtprovider default \
        --description "MACHINE ${machine}" \
        --audio-driver none --clipboard disabled --draganddrop disabled \
        --mouse usbtablet --keyboard usb --uartmode1 disconnected --uartmode2 disconnected \
        --cpus 4 --memory 4096 --tpm-type 1.2 --firmware efi64 --rtcuseutc on \
        --boot1 disk --boot2 none --boot3 none --boot4 none \
        --nic1 nat --nic2 null --nic3 null --nic4 null \
        --uart1 0x3F8 4 --uarttype1 16550A --uartmode1 server \\\\.\\pipe\\ttyS0 \
        --uart2 0x2F8 3 --uarttype2 16550A --uartmode2 server \\\\.\\pipe\\ttyS1 \
        --uart3 0x3E8 4 --uarttype3 16550A --uartmode3 server \\\\.\\pipe\\ttyS2 \
        --uart4 0x2E8 3 --uarttype4 16550A --uartmode4 server \\\\.\\pipe\\ttyS3

    VBoxManage.exe convertfromraw ${wsl_wic_path} "${VboxVMwin}\\${machine}\\${vdi_basename}.vdi" --format=vdi --variant=fixed

    VBoxManage.exe storageattach ${machine} --storagectl "SATA" --device 0 --port 0 --type hdd --medium "${VboxVMwin}\\${machine}\\${vdi_basename}.vdi"

    VBoxManage.exe modifynvram ${machine} inituefivarstore

    # rm -f ${wsl_wic_path}

    ;;

*)
    echo "unknown flash type ${flash_type}"
    ;;

esac

exit 0
