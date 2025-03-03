#!/bin/bash -x

# Utilize repo forall to run workflows

gh auth status

repo forall -g workflows -c '
echo "### $REPO_PATH"
cd $REPO_PATH
gh run list --limit 10 --json attempt,conclusion,createdAt,databaseId,displayTitle,event,headBranch,headSha,name,number,startedAt,status,updatedAt,url,workflowDatabaseId,workflowName \
  -t "{{range .}}{{tablerow .number .conclusion .displayTitle }}{{end}}"
'
