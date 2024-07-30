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

# Specialized DISTRO

Specialized DISTRO templates defined and used with layer scripting

| DISTRO | Description |
| --- | --- |
| distro-core | Core System, CLI Only |
| distro-full | Full System, CLI + GUI |

# Specialized MACHINE

Specialized MACHINE templates defined and used with layer scripting

| MACHINE | Description |
| --- | --- |
| com-cexpress-bt | COM [Adlink cExpress Type 6 Compact](https://www.adlinktech.com/Products/Computer_on_Modules/COMExpressType6Compact/cExpress-BT?lang=en) |
| com-cexpress-sl | COM [Adlink cExpress Type 6 Compact](https://www.adlinktech.com/Products/Computer_on_Modules/COMExpressType6Compact/cExpress-SL?lang=en) |
| sbc-gene-bt05 | SBC [Aaeon GENE-BT05](https://www.aaeon.com/en/p/3-and-half-inches-subcompact-boards-gene-bt05) |
| ~~sbc-raspberrypi5~~ | ~~SBC [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/)~~ |
| ~~sbc-xavier-nx-devkit~~ | ~~SBC [NVIDIA Jetson Xavier-NX DevKit](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-xavier-series/)~~ |

# Build Artifact Generation

Generation of build artifacts can be performed by use of the wrapper script to bitbake. The
following table indicates artifacts that have been generated at some point successfully. Default
targets are built by bitbake.

| DISTRO | MACHINE | Audit GPLv3 | Command |
| --- | --- | --- | --- |
| distro-core | com-cexpress-bt | X | scripts/images-build --distro=distro-core --machine=com-cexpress-bt |
| distro-core | com-cexpress-sl | X | scripts/images-build --distro=distro-core --machine=com-cexpress-sl |
| distro-core | sbc-gene-bt05 | X | scripts/images-build --distro=distro-core --machine=sbc-gene-bt05 |
| distro-full | sbc-gene-bt05 | X | scripts/images-build --distro=distro-full --machine=sbc-gene-bt05 |

Audit of GPLv3 supplies warning messages about packages used in a generated image. Primary use case is for
appropriate risk management with respect to any policy decisions about GPLv3 utilization. GPLv3 may carry
specific clauses that can potentially have implications of intellectual property rights reassignment.
