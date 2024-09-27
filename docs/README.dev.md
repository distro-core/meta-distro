## SPECIAL INSTRUCTIONS: LICENSE STANDARD

LICENSE = GPLv3: GPLv3 may carry specific clauses that can potentially have implications of intellectual
property rights reassignment. Do not bundle GPLv3 with any other license; GPLv3 may be incompatible
with the entire bundle. A contributor is expected to perform due diligence as part of the contribution.

LICENSE = CLOSED: CLOSED licenses are not compatible with the open source nature of **DISTRO**; please
do not contribute any materials with a CLOSED license. A contributor is expected to perform due diligence
as part of the contribution.

LICENSE = Proprietary: Proprietary licenses are not compatible with the open source nature of **DISTRO**; please
do not contribute any materials with a Proprietary license. A contributor is expected to perform due diligence
as part of the contribution.

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

## SPECIAL INSTRUCTIONS: LOCAL DEVELOPMENT

Repository meta-distro creates a local branch based from **yocto-lts-branch** branch. The
local branch naming scheme should include the the issue number, and a short slug that
helps to identify the feature.

```sh
git -C layers/meta-distro checkout -b ISSUE#-local-branch-name yocto-lts-branch
```

Development testing and builds are perfomed when the local branch is pushed to the server.
This is an iterative process as necessary, using the local branch, pushing, and building and testing
of the feature. It is expected that the local branch will be rebased to the tip of **yocto-lts-branch** as
needed to insure that builds and operation are staying current with the **yocto-lts-branch** branch.

Repository layers should use the following git command to commit. This insures a general format
for the commit message. The commit message should be a short description of the change. The commit
command uses a common template to create uniform commit log entries.

```sh
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

## GIT USER SETTINGS

Check for nominal git configuration settings; replace user.name, user.email, user.signingkey
as needed.

```sh
$ git config -l
user.name=Firstname Surname
user.email=XXXXXX+username@users.noreply.github.com
user.signingkey=GPG-KEY-ID
commit.gpgsign=true
commit.template=~/.config/git/commit.template
credential.helper=store --file=~/.config/git/credentials
core.autocrlf=false
init.defaultbranch=master
http.sslverify=true
url.https://.insteadof=git://
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
diff.tool=vscode
merge.tool=vscode
difftool.vscode.cmd=code --wait --diff $LOCAL $REMOTE
mergetool.vscode.cmd=code --wait $MERGED
includeif.gitdir:**/distro-core/.path=~/.config/git/config-github
includeif.gitdir:**/github/.path=~/.config/git/config-github
includeif.gitdir:**/gitlab/.path=~/.config/git/config-gitlab
~~~

## MIRROR: DOWNLOADS

When caches are setup, they can be accessed using environment variables that
are used by the bitbake build process.

Create an addition to ~/.bashrc

```sh
additionsadd() {
    if [[ " $BB_ENV_PASSTHROUGH_ADDITIONS " != *" $1 "* ]]; then
        # requires explicit export of variable in environment with value
        BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS:+"$BB_ENV_PASSTHROUGH_ADDITIONS "}$1"
    fi
}

additionsadd SOURCE_MIRROR_URL
additionsadd SSTATE_MIRRORS

export SOURCE_MIRROR_URL="https://distro-core/downloads"
export SSTATE_MIRRORS=" \
git://.*/.*     https://distro-core/sstate-cache/ \
ftp://.*/.*     https://distro-core/sstate-cache/ \
http://.*/.*    https://distro-core/sstate-cache/ \
https://.*/.*   https://distro-core/sstate-cache/ \
"
```

Create an addition to hosts file

```sh
<ip> distro-core
```

## ENVIRONMENT VARIABLES

Environment variables are utilized to selectivly set specific bitbake variables in the example build
script located at scripts/images-build. It is possible to extend the list by use of environment variables
as shown. Other variables can be found in the example CI/CD script scripts/images-build.

```sh
additionsadd DISTRO
additionsadd MACHINE
additionsadd BB_NUMBER_THREADS
additionsadd PARALLEL_MAKE
additionsadd DEPLOY_DIR
```
