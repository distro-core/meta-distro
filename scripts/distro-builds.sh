#!/bin/bash

# repo forall -c 'git checkout $REPO_LREV' # detached HEAD
# repo forall -c 'git checkout $REPO_RREV' # branch reference

repo sync

layers/meta-distro/scripts/distro-build.sh --preserve-build
layers/meta-distro/scripts/distro-build.sh --preserve-build --machine=wsl-amd64
