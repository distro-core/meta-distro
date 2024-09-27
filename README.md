# Repository meta-distro

This repository contains recipe files and scripts for distribution. The distribution is based
on Yocto tools to create a specialized Linux distro. The current distribution is based from
the [Yocto Release **scarthgap**](https://wiki.yoctoproject.org/wiki/Releases).

The repository is partitioned by Yocto Release code name as the branch.

# LICENSE Notes

For all original content supplied with this layer, unless otherwise specified, is licensed
as [LICENSE](./LICENSE).

Editorial discretion is asserted on specific inclusion of layers that may referenced. All
upstream packages and their source code come with their respective licenses. Individual packages
license terms are to be respected and followed.

# GPLv3 Audit

Audit of GPLv3 supplies warning messages about packages used in a generated image. Primary use case is for
appropriate risk management with respect to any policy decisions about GPLv3 utilization. GPLv3 carries
specific clauses that potentially have implications of intellectual property rights reassignment.

# DISTRO Specialization

Specialized DISTRO defined and used with layer scripting

| DISTRO | Description |
| --- | --- |
| conf/distro/distro-core.conf | Core System, CLI Only, C/C++ Runtime glibc |
| conf/distro/distro-core-gui.conf | Full System, CLI + GUI, C/C++ Runtime glibc |
| conf/distro/distro-musl.conf | Core System, CLI Only, C/C++ Runtime musl |
| conf/distro/distro-musl-gui.conf | Full System, CLI + GUI, C/C++ Runtime musl |
| conf/distro/distro-tiny.conf | Tiny System |
| conf/distro/include/*.conf | Shared configuration items for a specific feature, included by 'require' |

# MACHINE Specialization

Specialized MACHINE defined and used with layer scripting

| MACHINE | BSP | Type | Description |
| --- | --- | --- | --- |
| conf/machine/com-cexpress-bt.conf | meta-intel | COM | [Intel Baytrail, Core i5/i7 Adlink cExpress-bt Type 6 Compact](./conf/machine/com-cexpress-bt.conf) |
| conf/machine/com-cexpress-sl.conf | meta-intel | COM | [Intel SkyLake, Core i5/i7 Adlink cExpress-sl Type 6 Compact](./conf/machine/com-cexpress-sl.conf) |
| conf/machine/sbc-gene-bt05.conf | meta-intel | SBC | [Intel Baytrail, Atom E3845 Aaeon GENE-BT05](./conf/machine/sbc-gene-bt05.conf) |
| conf/machine/sbc-raspberrypi5.conf | meta-raspberrypi | SBC | [Raspberry Pi 5](./conf/machine/sbc-raspberrypi5.conf) |
| conf/machine/sbc-xavier-nx-devkit.conf | meta-tegra | SBC | [NVIDIA Jetson Xavier-NX DevKit](./conf/machine/sbc-xavier-nx-devkit.conf) |
| conf/machine/include/*.conf | | | Shared configuration items for a specific feature, included by 'require' |

# Build Artifact Generation

One time host initialization

```sh
# initialization of proxy
# cat >>~/.bashrc <<EOF
# export http_proxy=http://localhost:3128
# EOF

# initialization of yocto host dependency
.repo/manifests/scripts/setup-host-deps.sh

# initialization of WSL2 instance soft links to USERPROFILE
.repo/manifests/scripts/setup-home-links.sh
```

Generation of build artifacts can be performed by use of the wrapper script to bitbake. The
following table indicates artifacts that have been generated at some point successfully. See
scripts/images-build.sh for additional parameters.

-   all downloads

    ```sh
    distros="distro-core distro-core-gui distro-musl distro-musl-gui"
    machines="com-cexpress-bt com-cexpress-sl sbc-gene-bt05 sbc-raspberrypi5 sbc-xavier-nx-devkit"
    targets="distro-image distro-sdk-image"
    scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}" --target-flags="--continue" --fetch-downloads --clean-sstate
    ```

-   update s3://distro-core-downloads
    ```sh
    bucket=distro-core-downloads
	s3cmd --config ~/.config/s3cmd/config expire s3://$bucket
	# s3cmd --config ~/.config/s3cmd/config setacl s3://$bucket --acl-private
    # s3cmd --config ~/.config/s3cmd/config rm --recursive --force s3://$bucket
    # --add-header="$(date '+Expires:%a, %d %b %Y %H:%M:%S %Z' --universal --date='14 days')"
	s3cmd --config ~/.config/s3cmd/config sync --recursive --progress --acl-public \
		--exclude 'git2/*' --exclude '*.done' --exclude '*.lock' --exclude 'tmp*' --exclude '*tmp' \
		build/downloads/ s3://$bucket
    ```

-   build all distro, all machine

    ```sh
    # export DL_DIR=/nfs/shared/downloads
    # export SSTATE_DIR=/nfs/shared/sstate-cache
    distros="distro-core distro-core-gui distro-musl distro-musl-gui"
    machines="com-cexpress-bt com-cexpress-sl sbc-gene-bt05 sbc-raspberrypi5 sbc-xavier-nx-devkit"
    targets="distro-image distro-sdk-image"
    scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}"
    ```

-   update s3://distro-core-sstate-cache
    ```sh
    bucket=distro-core-sstate-cache
	s3cmd expire s3://$bucket
	# s3cmd setacl s3://$bucket --acl-private
	# s3cmd rm --recursive --force s3://$bucket
	# --add-header="$(date '+Expires:%a, %d %b %Y %H:%M:%S %Z' --universal --date='14 days')"
	s3cmd sync --recursive --progress --acl-public --no-delete-removed \
		build/sstate-cache/ s3://$bucket
    ```

-   update s3://distro-core-ostree
    ```sh
    distros="distro-core distro-core-gui distro-musl distro-musl-gui"
    machines="com-cexpress-bt com-cexpress-sl sbc-gene-bt05 sbc-raspberrypi5 sbc-xavier-nx-devkit"
    targets="distro-image distro-sdk-image"
    bucket=distro-core-ostree
	s3cmd expire s3://$bucket
	s3cmd setacl s3://$bucket --acl-private
    for distro in ${distros} ; do
		for machine in ${machines} ; do
            ostree_repo=build/${distro}/tmp-${machine}/deploy/ostree_repo
			if [[ -d ${ostree_repo} ]]; then
	            # s3cmd rm --recursive --force s3://$bucket
				# --add-header="$(date '+Expires:%a, %d %b %Y %H:%M:%S %Z' --universal --date='14 days')"
				s3cmd sync --recursive --progress --acl-public --delete-removed \
		            --exclude '*.lock' --exclude 'tmp*' --exclude '*tmp' \
					${ostree_repo}/ s3://$bucket/${distro}/${machine}/
			fi
		done
	done
    ```

-   distro-core

    ```sh
    # export DL_DIR=/nfs/shared/downloads
    # export SSTATE_DIR=/nfs/shared/sstate-cache
    distros="distro-core"
    machines="sbc-gene-bt05"
    targets="distro-image distro-sdk-image"
    scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}"
    ```

-   distro-core-gui

    ```sh
    # export DL_DIR=/nfs/shared/downloads
    # export SSTATE_DIR=/nfs/shared/sstate-cache
    distros="distro-core-gui"
    machines="sbc-gene-bt05"
    targets="distro-image distro-sdk-image"
    scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}"
    ```

-   distro-musl

    ```sh
    # export DL_DIR=/nfs/shared/downloads
    # export SSTATE_DIR=/nfs/shared/sstate-cache
    distros="distro-musl"
    machines="sbc-gene-bt05"
    targets="distro-image distro-sdk-image"
    scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}"
    ```

-   distro-musl-gui

    ```sh
    # export DL_DIR=/nfs/shared/downloads
    # export SSTATE_DIR=/nfs/shared/sstate-cache
    distros="distro-musl-gui"
    machines="sbc-gene-bt05"
    targets="distro-image distro-sdk-image"
    scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}"
    ```

-   distro-tiny (incomplete)

    ```sh
    # export DL_DIR=/nfs/shared/downloads
    # export SSTATE_DIR=/nfs/shared/sstate-cache
    # distros="distro-tiny"
    # machines="sbc-gene-bt05"
    # targets="distro-image distro-sdk-image"
    # scripts/images-build.sh --distro="${distros}" --machine="${machines}" --target="${targets}"
    ```
