# Repository meta-distro

This repository contains recipe files and scripts for distribution. The distribution is based
on Yocto tools to create a specialized Linux distro. The current distribution is based from
the [Yocto Release **scarthgap**](https://wiki.yoctoproject.org/wiki/Releases).

The repository is partitioned by Yocto Release code name as the branch.

For all original content supplied with this layer; unless otherwise specified, the content
is licensed as [LICENSE](./LICENSE).

Editorial discretion is asserted on specific inclusion of layers that may referenced. All
packages and their source code come with their respective licenses. Individual packages
license terms are to be respected and followed.

# DISTRO Specialization

Specialized DISTRO defined and used with layer scripting

| DISTRO | Description |
| --- | --- |
| conf/distro/distro-core.conf | Core System, CLI Only, C/C++ Runtime glibc |
| conf/distro/distro-core-gui.conf | Full System, CLI + GUI, C/C++ Runtime glibc |
| conf/distro/include/*.conf | Shared configuration items for a specific feature, included by 'require' |
<!--
| conf/distro/distro-musl.conf | Core System, CLI Only, C/C++ Runtime musl |
| conf/distro/distro-musl-gui.conf | Full System, CLI + GUI, C/C++ Runtime musl |
| conf/distro/distro-tiny.conf | Tiny System |
-->

# MACHINE Specialization

Specialized MACHINE defined and used with layer scripting

| MACHINE | BSP | Type | Description |
| --- | --- | --- | --- |
| conf/machine/com-cexpress-bt.conf | meta-intel | COM | [Intel Baytrail, Core i5/i7 Adlink cExpress-bt Type 6 Compact](./conf/machine/com-cexpress-bt.conf) |
| conf/machine/com-cexpress-sl.conf | meta-intel | COM | [Intel SkyLake, Core i5/i7 Adlink cExpress-sl Type 6 Compact](./conf/machine/com-cexpress-sl.conf) |
| conf/machine/sbc-gene-bt05.conf | meta-intel | SBC | [Intel Baytrail, Atom E3845 Aaeon GENE-BT05](./conf/machine/sbc-gene-bt05.conf) |
| conf/machine/include/*.conf | | | Shared configuration items for a specific feature, included by 'require' |
<!--
| conf/machine/sbc-raspberrypi5.conf | meta-raspberrypi | SBC | [Raspberry Pi 5](./conf/machine/sbc-raspberrypi5.conf) |
| conf/machine/sbc-xavier-nx-devkit.conf | meta-tegra | SBC | [NVIDIA Jetson Xavier-NX DevKit](./conf/machine/sbc-xavier-nx-devkit.conf) |
-->

# Build Artifact Generation

One time initialization

```sh
# initialization of yocto host dependency
scripts/setup-host-deps

# initialization of WSL2 instance soft links to USERPROFILE
scripts/setup-home-links

# initialization of proxy and cache environment
cat >>~/.bashrc <<EOF
# export SOURCE_MIRROR_URL=https://localhost/downloads
# export http_proxy=http://localhost:3128
# export https_proxy=http://localhost:3128
# export ftp_proxy=http://localhost:3128
# export ALL_PROXY=http://localhost:3128
# export all_proxy=http://localhost:3128
# export no_proxy=local
EOF
```

Generation of build artifacts can be performed by use of the wrapper script to bitbake. The
following table indicates artifacts that have been generated at some point successfully. See
scripts/images-build for additional parameters.

-   distro-core

    ```sh
    # distro-core com-cexpress-bt
    scripts/images-build --distro=distro-core --machine=com-cexpress-bt --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-core --machine=com-cexpress-bt
    ```

    ```sh
    # distro-core com-cexpress-sl
    scripts/images-build --distro=distro-core --machine=com-cexpress-sl --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-core --machine=com-cexpress-sl
    ```

    ```sh
    # distro-core sbc-gene-bt05
    scripts/images-build --distro=distro-core --machine=sbc-gene-bt05 --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-core --machine=sbc-gene-bt05
    ```

    ```sh
    # distro-core-gui sbc-gene-bt05
    scripts/images-build --distro=distro-core-gui --machine=sbc-gene-bt05 --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-core-gui --machine=sbc-gene-bt05
    ```

    ```sh
    # distro-core sbc-raspberrypi5
    scripts/images-build --distro=distro-core --machine=sbc-raspberrypi5 --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-core --machine=sbc-raspberrypi5
    ```

    ```sh
    # distro-core sbc-xavier-nx-devkit
    scripts/images-build --distro=distro-core --machine=sbc-xavier-nx-devkit --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-core --machine=sbc-xavier-nx-devkit
    ```

-   distro-musl

    ```sh
    # distro-musl sbc-gene-bt05
    scripts/images-build --distro=distro-musl --machine=sbc-gene-bt05 --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-musl --machine=sbc-gene-bt05
    ```

-   distro-tiny

    ```sh
    # distro-tiny sbc-gene-bt05
    scripts/images-build --distro=distro-tiny --machine=sbc-gene-bt05 --target-flags="--runall=fetch"
    scripts/images-build --distro=distro-tiny --machine=sbc-gene-bt05
    ```

Audit of GPLv3 supplies warning messages about packages used in a generated image. Primary use case is for
appropriate risk management with respect to any policy decisions about GPLv3 utilization. GPLv3 carries
specific clauses that potentially have implications of intellectual property rights reassignment.
