#!/bin/bash

distro_codename=scarthgap

# setup working directory
mkdir -p /srv/repo/distro-core && cd /srv/repo/distro-core
printf "\n\ny\n\n" | repo init -u https://github.com/distro-core/distro-manifest.git -b main -m distro-head-$distro_codename.xml --no-clone-bundle
repo sync
