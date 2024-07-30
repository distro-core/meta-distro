
## SPECIAL INSTRUCTIONS: PACKAGE STANDARD

SGID/SUID Permissions - Programs should not arbitrarily be granted SGID or SUID permissions;
such permissions may be possible to utilize as a security breach gadget. When necessary, use
image-sgid-suid-set.bbclass to keep the list of these exceptions in a central location. Do not apply
SGID or SUID permissions from a recipe. The appropriate location for SGID or SUID permissions changes
is in the image-sgid-suid-set.bbclass.

Packagegroups - All packagegroups for meta-distro are managed in a single recipe: packagegroup-distro.bb.
The recipe contains instructions on how to add and remove package groups and associated recipes. By policy,
there is no method for .bbappends adding to packagegroups-distro; make all changes directly to the
packagegroup recipe.

LICENSE = GPLv3: GPLv3 licenses may have the ability to absorb intellectual property and relicense the
intellectual property as GPLv3. Do not bundle GPLv3 with any other license; GPLv3 may be incompatible
with the entire bundle. A contributor is expected to perform due diligence as part of the contribution.

LICENSE = CLOSED: CLOSED licenses are not compatible with the open source nature of **DISTRO**; please
do not contribute any materials with a CLOSED license.

LICENSE = Proprietary: Proprietary licenses are not compatible with the open source nature of **DISTRO**; please
do not contribute any materials with a Proprietary license.

## SPECIAL INSTRUCTIONS: LOCAL DEVELOPMENT

Repository meta-distro creates a local branch based from **yocto-lts-branch** branch. The
local branch naming scheme should include the the issue number, and a short slug that
helps to identify the feature.

```console
git -C layers/meta-distro checkout -b ISSUE#-local-branch-name yocto-lts-branch
```

Development testing and builds are perfomed when the local branch is pushed to the server.
This is an iterative process as necessary, using the local branch, pushing, and building and testing
of the feature. It is expected that the local branch will be rebased to the tip of **yocto-lts-branch** as
needed to insure that builds and operation are staying current with the **yocto-lts-branch** branch.

Repository layers should use the following git command to commit. This insures a general format
for the commit message. The commit message should be a short description of the change. The commit
command uses a common template to create uniform commit log entries.

```console
git -C layers/meta-distro commit --template ~/.config/git/commit.template --edit --signoff --gpg-sign
git -C layers/meta-distro push -u origin ISSUE#-local-branch-name
```

A pull request should be made when the local branch is ready to be merged into the **yocto-lts-branch** branch. Use
the repository server to create the pull request from the local branch to the **yocto-lts-branch** branch. Verify
the pull request builds successfully before merging. The pull request should be reviewed by a second person.
The pull request should be merged by a second person. The pull request should delete the source branch upon
successful merge. The pull request should be closed by the repository server. Insure the pull request is rebased
to the HEAD of **yocto-lts-branch** branch and tested to build before merging.

There are no upstream changes to the **yocto-lts-branch** branch. The **yocto-lts-branch** branch is the main branch for all
development pull requests. The **yocto-lts-branch** branch is the main branch for all releases. The repo tool is used to
manage the commit-id's for all repositories. The repo tool will sync all repositories to the commit-id's for all
branches used in the final build.

## ENVIRONMENT VARIABLES

Environment variables are utilized to selectivly set specific bitbake variables in the example build
script located at scripts/images-build. It is possible to extend the list by use of environment variables
as shown:

```console
# Example to enable environment override of variables
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} DISTRO"
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} MACHINE"
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} BB_NUMBER_THREADS"
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} PARALLEL_MAKE"
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} DEPLOY_DIR"
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} SDKMACHINE"
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} TOOLCHAIN"
```
