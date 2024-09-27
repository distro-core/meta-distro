#!/bin/bash

set -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_NAME=$(basename $0)

VALID_ARGS=$(getopt -o habc:dsD:M:Tt::p:F --long help,preserve-artifacts,preserve-build,clean-targets:,clean-download,clean-sstate,distro:,machine:,target:,target-flags:,proxy:,fetch-downloads -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help)
            echo "Usage: $SCRIPT_NAME [--distro='distro_list'] [--machine='<machine_list>'] [--target='<target_list>']"
            echo "--distro='distro_list'           set distro_list"
            echo "--machine='<machine_list>'       set machine_list"
            echo "--target='<target_list>'         set target_list"
            echo "--target-flags='<flags_list>'    set target_flags"
            # echo "--preserve-artifacts             preserve artifacts"
            echo "--preserve-build                 preserve build"
            echo "--clean-download                 clean downloads"
            echo "--clean-sstate                   clean sstate-cache"
            echo "--clean-targets='<target_list>'  clean target_list"
            # echo "--proxy='proxy'                  set proxy url"
            exit 0
            ;;
        -a | --preserve-artifacts)
            preserve_artifacts=1
            shift
            ;;
        -b | --preserve-build)
            preserve_build=1
            shift
            ;;
        -c | --clean-target)
            clean_targets=( $2 )
            shift 2
            ;;
        -d | --clean-download)
            clean_downloads=1
            shift
            ;;
        -s | --clean-sstate)
            clean_sstate=1
            shift
            ;;
        -D | --distro)
            distros=( $2 )
            shift 2
            ;;
        -M | --machine)
            machines=( $2 )
            shift 2
            ;;
        -T | --target)
            targets=( $2 )
            shift 2
            ;;
        -t | --target-flags)
            targets_flags=( $2 )
            shift 2
            ;;
        -p | --proxy)
            proxy=$2
            shift 2
            ;;
        -F | --fetch-downloads)
            targets_flags=( --runall=fetch ${targets_flags[*]} )
            shift
            ;;
        -H | --hashserv)
            hashserv=$2
            shift 2
            ;;
        -P | --prserv)
            prserv=$2
            shift 2
            ;;
        --) shift
            break
            ;;
    esac
done

clean_dir() {
    echo "INFO: clean $1"
    if [[ -d $1 ]]; then
        rm -fr $1/
    fi
}

if [[ ${#distros[*]} -eq 0 ]]; then
    distros=( distro-core )
    echo "INFO: set default distros to ${distros[*]}"
fi

if [[ ${#machines[*]} -eq 0 ]]; then
    machines=( sbc-gene-bt05 )
    echo "INFO: set default machines to ${machines[*]}"
fi

if [[ ${#targets[*]} -eq 0 ]]; then
    targets=( distro-image distro-sdk-image )
    echo "INFO: set default targets to ${targets[*]}"
fi

# if [[ -n "${proxy}" ]]; then
#     proto="$(echo ${proxy} | grep :// | sed -e's,^\(.*://\).*,\1,g')"
#     url="$(echo ${proxy/$proto/})"
#     user="$(echo $url | grep @ | cut -d@ -f1)"
#     hostport="$(echo ${url/$user@/} | cut -d/ -f1)"
#     host="$(echo $hostport | sed -e 's,:.*,,g')"
#     port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
#     path="$(echo $url | grep / | cut -d/ -f2-)"
#     if socat /dev/null TCP:$host:$port >/dev/null; then
#         echo "INFO: set proxy to ${proxy}"
#         export http_proxy=${proxy}
#         export https_proxy=${proxy}
#         export no_proxy="10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8"
#     fi
# fi

if [[ -n "${clean_downloads}" ]]; then
    clean_dir build/downloads
else
    echo "INFO: retain build/downloads"
fi

if [[ -n "${clean_sstate}" ]]; then
    clean_dir build/sstate-cache
else
    echo "INFO: retain build/sstate-cache"
fi

for distro in ${distros[*]} ; do

    topdir=build/${distro} # aka TOPDIR

    if [[ -n "${preserve_build}" ]]; then
        echo "INFO: retain ${topdir}"
        clean_dir ${topdir}/conf
    else
        clean_dir ${topdir}
    fi

    mkdir -p ${topdir}

done

[[ -z "${MANIFEST_BRANCH}" ]] && export MANIFEST_BRANCH="$(git -C .repo/manifests rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" | cut -d'/' -f2)"
[[ -z "${MANIFEST_COMMIT_ID}" ]] && export MANIFEST_COMMIT_ID="$(git -C .repo/manifests rev-parse HEAD)"
[[ -z "${MANIFEST_NAME}" ]] && export MANIFEST_NAME="$(xmllint --xpath "string(//include/@name)" .repo/manifest.xml)"
[[ -z "${MANIFEST_SERIAL}" ]] && export MANIFEST_SERIAL=$(/bin/date -u "+%Y%m%d%H%M%S")

for distro in ${distros[*]} ; do

    for machine in ${machines[*]} ; do

        topdir=build/${distro} # aka TOPDIR

        orig_cwd=$(pwd)

        export DISTRO=${distro}
        export MACHINE=${machine}

        rm -fr ${topdir}/conf

        {
        source scripts/oe-init-build-env ${topdir}
        } >/dev/null

        rm -f *.lock *.sock

        echo "INFO: BEGIN ${distro} ${machine} ${targets[*]}"

        # if [[ ${#clean_targets[*]} -ne 0 ]]; then
        #     command -p time bitbake -c cleansstate ${clean_targets[*]}
        # fi

        command -p time bitbake ${targets_flags[*]} ${targets[*]}

        echo "INFO: END ${distro} ${machine} ${targets[*]}"

        cd ${orig_cwd}

    done

done

# if [[ -n "${clean_downloads}" ]]; then
#     s3cmd rm --recursive --force s3://distro-core-downloads
#     s3cmd sync --recursive --progress --acl-public \
#         --exclude 'git2/*' --exclude '*.done' --exclude '*.lock' --exclude 'tmp*' --exclude '*tmp' \
#         build/downloads/ s3://distro-core-downloads
# fi

# if [[ -n "${clean_sstate}" ]]; then
#     s3cmd rm --recursive --force s3://distro-core-sstate-cache
#     s3cmd sync --recursive --progress --acl-public \
#         build/sstate-cache/ s3://distro-core-sstate-cache
# fi

exit 0
