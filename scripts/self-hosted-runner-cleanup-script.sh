#!/bin/bash

LOG=/srv/actions-runner/self-hosted-runner-cleanup-script.log

# Print the environment variables on a self-hosted runner.

env | sort | tee $LOG

# List files from the downloads and sstate-cache directories older
# than 90 days on a self-hosted runner.

find $GITHUB_WORKSPACE/build/downloads -mindepth 1 -mtime +90 -print | tee -a $LOG
find $GITHUB_WORKSPACE/build/sstate-cache -mindepth 1 -mtime +90 -print | tee -a $LOG

# Remove files from the downloads and sstate-cache directories older
# than 90 days on a self-hosted runner.

# find $GITHUB_WORKSPACE/build/downloads -mindepth 1 -mtime +90 -delete | tee -a $LOG
# find $GITHUB_WORKSPACE/build/sstate-cache -mindepth 1 -mtime +90 -delete | tee -a $LOG

# Remove softlinks from the downloads and sstate-cache directories on
# a self-hosted runner.

# find $GITHUB_WORKSPACE/build/downloads -type l -exec rm -f \{\} \;
# find $GITHUB_WORKSPACE/build/sstate-cache -type l -exec rm -f \{\} \;
