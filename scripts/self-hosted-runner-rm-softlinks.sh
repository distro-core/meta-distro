#!/bin/bash -x

# Remove softlinks from the downloads and sstate-cache directories on a self-hosted runner

# cd /srv/actions-runner/_work

find workflows-com-cexpress-bt/workflows-com-cexpress-bt/build/downloads -type l -exec rm -f \{\} \;

find workflows-com-cexpress-sl/workflows-com-cexpress-sl/build/downloads -type l -exec rm -f \{\} \;

find workflows-sbc-gene-bt05/workflows-sbc-gene-bt05/build/downloads -type l -exec rm -f \{\} \;

find workflows-sbc-raspberrypi5/workflows-sbc-raspberrypi5/build/downloads -type l -exec rm -f \{\} \;

find workflows-wsl-amd64/workflows-wsl-amd64/build/downloads -type l -exec rm -f \{\} \;

find workflows-com-cexpress-bt/workflows-com-cexpress-bt/build/sstate-cache -type l -exec rm -f \{\} \;

find workflows-com-cexpress-sl/workflows-com-cexpress-sl/build/sstate-cache -type l -exec rm -f \{\} \;

find workflows-sbc-gene-bt05/workflows-sbc-gene-bt05/build/sstate-cache -type l -exec rm -f \{\} \;

find workflows-sbc-raspberrypi5/workflows-sbc-raspberrypi5/build/sstate-cache -type l -exec rm -f \{\} \;

find workflows-wsl-amd64/workflows-wsl-amd64/build/sstate-cache -type l -exec rm -f \{\} \;
