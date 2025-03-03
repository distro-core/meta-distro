#!/bin/bash

set -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )
SCRIPT_NAME=$(basename $0)

VALID_ARGS=$(getopt -o hbc:dsD:M:Tt::p:F --long help,preserve-build,clean-targets:,clean-download,clean-sstate,distro:,machine:,target:,target-flags:,proxy:,fetch-downloads -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help)
            echo "Usage: ${SCRIPT_NAME} [--distro='distro_list'] [--machine='<machine_list>'] [--target='<target_list>']"
            echo "--distro='distro_list'           set distro_list"
            echo "--machine='<machine_list>'       set machine_list"
            echo "--target='<target_list>'         set target_list"
            echo "--target-flags='<flags_list>'    set target_flags"
            echo "--preserve-build                 preserve build"
            echo "--clean-downloads                clean downloads"
            echo "--clean-sstate                   clean sstate-cache"
            # echo "--clean-target='<target_list>'  clean target_list"
            # echo "--proxy='proxy'                  set proxy url"
            exit 0
            ;;
        -b | --preserve-build)
            preserve_build=1
            shift
            ;;
        -c | --clean-target)
            clean_targets=( $2 )
            shift 2
            ;;
        -d | --clean-downloads)
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
    echo "NOTE: clean $1"
    if [[ -d $1 ]]; then
        rm -fr $1/
    fi
}

if [[ ${#distros[*]} -eq 0 ]]; then
    distros=( distro-core )
    echo "NOTE: set default distros to ${distros[*]}"
fi

if [[ ${#machines[*]} -eq 0 ]]; then
    machines=( com-cexpress-bt )
    echo "NOTE: set default machines to ${machines[*]}"
fi

if [[ ${#targets[*]} -eq 0 ]]; then
    targets=( distro-image distro-image-full )
    echo "NOTE: set default targets to ${targets[*]}"
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
#         echo "NOTE: set proxy to ${proxy}"
#         export http_proxy=${proxy}
#         export https_proxy=${proxy}
#         export no_proxy="10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8"
#     fi
# fi

if [[ -n "$clean_downloads" ]]; then
    clean_dir "build/downloads/*"
else
    echo "NOTE: retain build/downloads"
fi

for distro in ${distros[*]} ; do

    topdir=build # aka TOPDIR

    mkdir -p $topdir

    for machine in ${machines[*]} ; do

        if [[ -n "$clean_sstate" ]]; then
            clean_dir "build/sstate-cache/*"
        else
            echo "NOTE: retain build/sstate-cache"
        fi

    done

    if [[ -n "${preserve_build}" ]]; then
        echo "NOTE: retain $topdir"
        clean_dir $topdir/conf
    else
        clean_dir $topdir/conf
        clean_dir $topdir/tmp*
    fi

done

for distro in ${distros[*]} ; do

    for machine in ${machines[*]} ; do

        topdir=build # aka TOPDIR

        orig_cwd=$(pwd)

        export DISTRO=$distro
        export MACHINE=$machine

        rm -fr $topdir/conf

        { source $SCRIPT_DIR/oe-init-build-env $topdir ; } >/dev/null

        rm -f *.lock *.sock

        echo "NOTE: BEGIN $distro $machine ${targets[*]}"

        # if [[ ${#clean_targets[*]} -ne 0 ]]; then
        #     bitbake -c cleansstate ${clean_targets[*]}
        # fi

        echo "DISTRO_FEATURES: $(bitbake-getvar --quiet --value DISTRO_FEATURES | tr -s '[:blank:]')"
        echo "DISTROOVERRIDES: $(bitbake-getvar --quiet --value DISTROOVERRIDES | tr -s '[:blank:]')"
        echo "MACHINE_FEATURES: $(bitbake-getvar --quiet --value MACHINE_FEATURES | tr -s '[:blank:]')"
        echo "MACHINEOVERRIDES: $(bitbake-getvar --quiet --value MACHINEOVERRIDES | tr -s '[:blank:]')"

        bitbake_rc=0
        bitbake ${targets_flags[*]} ${targets[*]} || ( bitbake_rc=$? ; echo bitbake_rc=$bitbake_rc )

        # if [[ $bitbake_rc -eq 0 ]] ; then
        #     DISTRO_CODENAME=$(bitbake-getvar --quiet --value DISTRO_CODENAME)
        #     repo manifest --pretty --output-file distro-head-$DISTRO_CODENAME.xml || true
        #     repo manifest --pretty --revision-as-HEAD --output-file distro-refs-$DISTRO_CODENAME.xml || true
        # fi

        echo "NOTE: END $distro $machine ${targets[*]}"

        cd $orig_cwd

    done

done

exit 0
