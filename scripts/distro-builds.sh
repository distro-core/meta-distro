#!/bin/bash

# export EXTRA_PREMIRRORS=" \
# cvs://\.\*/\.*\ https://downloads.domain.com \
# svn://\.\*/\.\* https://downloads.domain.com \
# git://\.\*/\.\* https://downloads.domain.com \
# gitsm://\.\*/\.\* https://downloads.domain.com \
# bzr://\.\*/\.\* https://downloads.domain.com \
# p4://\.\*/\.\* https://downloads.domain.com \
# osc://\.\*/\.\* https://downloads.domain.com \
# https?://\.\*/\.\* https://downloads.domain.com \
# ftp://\.\*/\.\* https://downloads.domain.com \
# npm://.*/?.* https://downloads.domain.com \
# s3://\.\*/\.\* https://downloads.domain.com \
# crate://\.\*/\.\* https://downloads.domain.com \
# gs://.*/. https://downloads.domain.com \
# "
# export EXTRA_SSTATE_MIRRORS=" \
# file://\.\* https://sstate-cache.domain.com/PATH \
# "

# repo forall -c 'git checkout $REPO_RREV'  # branch references

repo forall -c 'git checkout $REPO_LREV'    # commit-id references

repo sync

layers/meta-distro/scripts/distro-build.sh --preserve-build
layers/meta-distro/scripts/distro-build.sh --preserve-build --machine=wsl-amd64
