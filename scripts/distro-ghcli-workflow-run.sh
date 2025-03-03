#!/bin/bash -x

# Run the GitHub CLI workflow for the Cloud Parse, Cloud Fetch, 
# Runner Fetch, and Runner Build workflows.

# gh auth login

for i in workflows/workflows-*; do

pushd $i

    gh workflow run "Cloud Parse" 

    gh workflow run "Cloud Fetch" 

    gh workflow run "Runner Fetch" -f "chosen_os=ubuntu-24.04" -f "EXTRA_USER_CLASSES=none"

    gh workflow run "Runner Build" -f "chosen_os=ubuntu-24.04" -f "EXTRA_USER_CLASSES=none"

popd

done
