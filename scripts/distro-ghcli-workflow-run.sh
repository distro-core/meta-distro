#!/bin/bash -x

# Utilize repo forall to run workflows

gh auth status

repo forall -g workflows -c '
echo "### $REPO_PATH"
cd $REPO_PATH
echo gh workflow run self-hosted-fetch.yml -r $REPO_RREV  -f chosen_os=ubuntu-24.04 -f EXTRA_USER_CLASSES=none
echo gh workflow run self-hosted-build.yml -r $REPO_RREV -f chosen_os=ubuntu-24.04 -f EXTRA_USER_CLASSES=none
gh workflow run github-hosted-parse.yml -r $REPO_RREV
gh workflow run github-hosted-fetch.yml -r $REPO_RREV -f chosen_os=ubuntu-24.04 -f EXTRA_USER_CLASSES=none
gh workflow run github-hosted-build.yml -r $REPO_RREV -f chosen_os=ubuntu-24.04 -f EXTRA_USER_CLASSES=none
'
