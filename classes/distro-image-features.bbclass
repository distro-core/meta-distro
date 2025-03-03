# File: distro-image-features.bbclass
# SPDX-License-Identifier: MIT

# require by conf/local.conf

EXTRA_IMAGE_FEATURES ?= "debug-tweaks empty-root-password"

# splash screen on console
# IMAGE_FEATURES:remove = "splash"

# remove dbg packages
# IMAGE_FEATURES:remove = "dbg-pkgs"

# remove dev packages
# IMAGE_FEATURES:remove = "dev-pkgs"

# remove doc packages
IMAGE_FEATURES:remove = "doc-pkgs"

# remove lic packages
IMAGE_FEATURES:remove = "lic-pkgs"

# remove ptest packages
IMAGE_FEATURES:remove = "ptest-pkgs"

# remove static libraries
IMAGE_FEATURES:remove = "staticdev-pkgs"

# remove nfs server packages
IMAGE_FEATURES:remove = "nfs-server"

# remove package management (deb, ipk, rpm)
IMAGE_FEATURES:remove:sota = "package-management"

# remove perf packages
IMAGE_FEATURES:remove = "perf"

# remove dropbear ssh packages
IMAGE_FEATURES:remove = "ssh-server-dropbear"

# remove tools packages
# IMAGE_FEATURES:remove:production = "tools-debug"
# IMAGE_FEATURES:remove:production = "tools-sdk"
# IMAGE_FEATURES:remove:production = "tools-testapps"

# remove debug features
# IMAGE_FEATURES:remove:production = "${@d.getVar(oe.utils.vartrue('DEBUG_BUILD', '', 'debug-tweaks empty-root-password', d))}"

# ---
