#!/bin/bash

DELETE_REMOVED=""
SRC_DIR=build/downloads
DST_DIR=s3://distro-core-downloads

s3cmd --config $HOME/.s3cfg \
    sync --recursive --acl-public --preserve --no-follow-symlinks $DELETE_REMOVED --progress \
    --add-header "Expires: $(date --utc --date '90 days' '+%a, %d %b %Y %R:%S %Z')" \
    --exclude 'git2/' --exclude '*.done' --exclude '*.lock' --exclude 'tmp*' --exclude '*tmp' \
    $SRC_DIR/ $DST_DIR/

DELETE_REMOVED=""
SRC_DIR=build/sstate-cache
DST_DIR=s3://distro-core-sstate-cache

s3cmd --config $HOME/.s3cfg \
    sync --recursive --acl-public --preserve --no-follow-symlinks $DELETE_REMOVED --progress \
    --add-header "Expires: $(date --utc --date '90 days' '+%a, %d %b %Y %R:%S %Z')" \
    --exclude 'git2/' --exclude '*.done' --exclude '*.lock' --exclude 'tmp*' --exclude '*tmp' \
    $SRC_DIR/ $DST_DIR/
