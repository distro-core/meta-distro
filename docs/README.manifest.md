# Manifests

Manifests are descriptions of the repositories that are to be included in the build. The
repositories may be from the same organization or from different organizations. The manifest
files are stored in the .repo/manifests path upon initialization by the repo command. The
presence of a repository in layers/* does not automatically add it to the bitbake layers.

## Manifest Descriptions

Repository manifests

| Manifest | git refs | LTS | EOL | Description |
| --- | --- | --- | --- | --- |
| default.xml | HEAD | | | Soft link to current manifest |
| distro-head-kirkstone.xml | HEAD | X | 2026-04 | Yocto Kirkstone (4.0), Development |
| distro-head-scarthgap.xml | HEAD | X | 2028-05 | Yocto Scarthgap (5.0), Development |
| distro-refs-kirkstone.xml | commit-id | | | Yocto Kirkstone (4.0), Successful Build |
| distro-refs-scarthgap.xml | commit-id | | | Yocto Scarthgap (5.0), Successful Build |
| remotes-github.xml | - | | | Repo Remotes Definitions, Mirrors |
| remotes-origin.xml | - | | | Repo Remotes Definitions, Upstream |
| upstream-head-kirkstone.xml | HEAD | X | 2026-04 | Yocto Kirkstone (4.0), Upstream Definitions |
| upstream-head-scarthgap.xml | HEAD | X | 2028-05 | Yocto Scarthgap (5.0), Upstream Definitions |

## Manifest Sync

Example commands using [repo tool](https://gerrit.googlesource.com/git-repo) to init and sync

```sh
cd /srv/repo && git clone https://github.com/distro-core/distro-manifest.git distro-core && cd distro-core
repo init -u file://$(pwd) -b main -m distro-head-scarthgap.xml --no-clone-bundle
repo sync
```

## Manifest Build

Example commands using script to build

```sh
scripts/images-build --distro=distro-core --machine=sbc-gene-bt05
```

## Host Dependency Setup

Setup scripts require an existing dependcy to the sudo command working for the calling user.

Initialize host dependency in an instance

```sh
scripts/setup-host-deps
```

Initialize WSL2 dependency in an instance

```sh
scripts/setup-home-links
```
