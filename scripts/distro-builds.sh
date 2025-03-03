#!/bin/bash

set -euo pipefail

# Set up mirrors for source and sstate cache
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

# Sync all repos to the manifest revision
repo --no-pager forall --quiet --command 'git checkout $REPO_LREV >/dev/null || true'
repo --no-pager forall --quiet --command 'git branch -D $REPO_RREV >/dev/null || true'
repo --no-pager sync --quiet --force-sync
# repo --no-pager forall --quiet --command 'git checkout $REPO_RREV >/dev/null || true'
repo --no-pager status

# Build variants
/usr/bin/time -f 'NOTE: time %E %S %U %x %C' layers/meta-distro/scripts/distro-build.sh --preserve-build --machine=com-cexpress-bt
/usr/bin/time -f 'NOTE: time %E %S %U %x %C' layers/meta-distro/scripts/distro-build.sh --preserve-build --machine=wsl-amd64

# Uncomment to sync downloads and sstate-cache to S3
# /usr/bin/time -f 'NOTE: time %E %S %U %x %C' s3cmd sync --delete-removed --exclude 'git2/' --exclude 'tmp*/' --exclude '*.done' --exclude '*.lock' build/downloads/ s3://distro-core-downloads/
# /usr/bin/time -f 'NOTE: time %E %S %U %x %C' s3cmd sync --delete-removed --exclude 'git2/' --exclude 'tmp*/' --exclude '*.done' --exclude '*.lock' build/sstate-cache/ s3://distro-core-sstate-cache/
