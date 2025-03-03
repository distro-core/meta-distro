#!/bin/bash

set -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_NAME=$(basename $0)

VALID_ARGS=$(getopt -o hC:D:M:T:p: --long help,toolchain:,distro:,machine:,target:,proxy: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help)
            echo "Usage: $SCRIPT_NAME [-p|--proxy 'proxy'] -M|--machine 'machine' -T|--target 'target'"
            echo "--toolchain 'toolschain' set toolchain"
            echo "--distro 'distro' set distro"
            echo "--proxy 'proxy' set proxy url"
            echo "--machine 'machine' - not optional"
            echo "--target 'target' - not optional"
            exit 0
            ;;
        -C | --toolchain)
            TOOLCHAIN=$2
            shift 2
            ;;
        -D | --distro)
            DISTRO=$2
            shift 2
            ;;
        -M | --machine)
            MACHINE=$(echo $2 | cut -d' ' -f1)
            shift 2
            ;;
        -T | --target)
            TARGET=$(echo $2 | cut -d' ' -f1)
            shift 2
            ;;
        -p | --proxy)
            PROXY=$2
            shift 2
            ;;
        --) shift
            break
            ;;
    esac
done

if [[ -z "$DISTRO" ]]; then
    DISTRO=distro-core
    echo "set default DISTRO to $DISTRO"
fi

if [[ -z "$MACHINE" ]]; then
    echo "--machine 'machine list' is not optional"
    exit 1
fi

if [[ -z "$TARGET" ]]; then
    echo "--target 'target list' is not optional"
    exit 1
fi

if [[ -z "$TOOLCHAIN" ]]; then
    TOOLCHAIN=gcc
    echo "set default TOOLCHAIN to $TOOLCHAIN"
fi

if [[ -n "$PROXY" ]]; then

    proto="$(echo $PROXY | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    url="$(echo ${PROXY/$proto/})"
    user="$(echo $url | grep @ | cut -d@ -f1)"
    hostport="$(echo ${url/$user@/} | cut -d/ -f1)"
    host="$(echo $hostport | sed -e 's,:.*,,g')"
    port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
    path="$(echo $url | grep / | cut -d/ -f2-)"

    if socat /dev/null TCP:$host:$port >/dev/null; then
        echo "set proxy to $PROXY"
        export http_proxy=$PROXY
        export https_proxy=$PROXY
        export no_proxy="10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
    fi
fi

if ! git config --global url."https://".insteadOf git://; then
    echo "git config unable to set https:// insteaof git://"
    exit 1
fi

# export DISTRO=$1
# export MACHINE=$2
# export TARGET=$3

artifact_dir=$(pwd)/artifacts/$DISTRO-$MACHINE
build_dir=$(pwd)/build/$DISTRO-$MACHINE

(
    export MACHINE=$MACHINE
    export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} MACHINE"
    export DISTRO=$DISTRO
    export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} DISTRO"
    export TOOLCHAIN=$TOOLCHAIN
    export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} TOOLCHAIN"
    export BB_GENERATE_MIRROR_TARBALLS=1
    export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} BB_GENERATE_MIRROR_TARBALLS"
    export DEPLOY_DIR=$artifact_dir
    export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} DEPLOY_DIR"
    export SDKMACHINE=x86_64
    export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} SDKMACHINE"

    TEMPLATECONF=$(pwd)/layers/meta-distro/conf/machine/$MACHINE \
        source layers/poky/oe-init-build-env $build_dir

    wic list images

    wic create efiimage-sota -m -o $artifact_dir/images -e $TARGET

    runqemu --help

    runqemu slirp ovmf wic $MACHINE efiimage-sota

    # qemuparams="-virtfs local,path=$PWD/testfolder,security_model=none,mount_tag=host_share"
)
