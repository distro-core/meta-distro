# Repository meta-distro

This repository contains repo manifest files for the DISTRO Core distribution. The
distribution is based on Yocto tools to create a specialized Linux distro. The current
distribution available with the manifest [default.xml](./default.xml).

*   [Yocto Releases](https://wiki.yoctoproject.org/wiki/Releases)

The development tasks manual is a invaluable resource to understanding the intricacies of using
the project for creation of specialized Linux distributions.

*   [Yocto Project Development Tasks](https://docs.yoctoproject.org/dev-manual/index.html)

Repo is a tool built on top of Git. Repo helps manage many Git repositories, does the uploads to
revision control systems, and automates parts of the development workflow. Repo is not meant to
replace Git, only to make it easier to work with Git. Git projects are captured into XML files
for use by the repo tool. This allows for many different configurations and revisions to be
captured into one location.

*   [Repo Tool information](https://android.googlesource.com/tools/repo)

# LICENSE Information

- SPDX-License-Identifier: [GPL-2.0-or-later](https://spdx.org/licenses/GPL-2.0-or-later.html)
- SPDX-License-Identifier: [MIT](https://spdx.org/licenses/MIT.html)

Copyright (c) 2024 brainhoard.com

For all original content supplied with this layer, unless otherwise specified, is licensed
as [LICENSE](./LICENSE).

Editorial discretion is asserted on specific inclusion of layers that may referenced. All
upstream packages and their source code come with their respective licenses. Individual packages
license terms are to be respected.

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

