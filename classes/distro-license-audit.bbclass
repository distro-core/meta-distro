# included by build/conf/local.conf

# Implement GPLv3 license use checks by issuing a warning when a GPLv3 package is included
# into an image. The nominal operation of this bbclass can be turned off at build time by
# clearing the variable INCOMPATIBLE_LICENSE_EXCEPTIONS in the local.conf file.

# Each package entry is comprised of the following pattern, with package and license being
# replaced to reflect the actual package license. The list only captures GPLv3 licenses and
# related for audit purposes.

# if "", disables incompatible licenses check
INCOMPATIBLE_LICENSE ?= "AGPL-3.0-only AGPL-3.0-or-later GPL-3.0-only GPL-3.0-or-later LGPL-3.0-only LGPL-3.0-or-later"

# if "", incompatible licenses check has no exceptions
INCOMPATIBLE_LICENSE_EXCEPTIONS ?= "${DISTRO_LICENSE_AUDIT}"

# if "commercial", accept commercial sw such as ffmpeg
LICENSE_FLAGS_ACCEPTED += "commercial"

####################

def local_license_audit(pkgs, licenses, d):
    """ return string with packages associated to licenses """
    _ = d
    retval = ""
    for pkg in pkgs.split():
        for lic in licenses.split():
            retval += f"{pkg}:{lic} {pkg}-dbg:{lic} {pkg}-dev:{lic} {pkg}-doc:{lic} {pkg}-help:{lic} "
            retval += f"{pkg}-locale:{lic} {pkg}-ptest:{lic} {pkg}-staticdev:{lic} {pkg}-src:{lic} "
            retval += f"{pkg}-tool:{lic} "
    return retval

# *DO NOT DELETE ENTRIES* IN DISTRO_LICENSE_AUDIT; THE LIST IS UTILIZED TO BY EXCLUSION
# TO TERMINATE BITBAKE UNTIL THE LICNESE IS ADDED FOR EXCEPTION PROCESSES. THE LIST IS
# ONLY UPDATED TO AUDIT ENTRIES WHICH ARE KNOWN; THE LIST IS NOT EXHAUSTIVE OF ALL
# POSSIBLE ENTRIES.

DISTRO_LICENSE_AUDIT := " \
${@local_license_audit('accountsservice-locale-en-gb', 'GPL-3.0-only', d)} \
${@local_license_audit('accountsservice-locale-en', 'GPL-3.0-only', d)} \
${@local_license_audit('accountsservice', 'GPL-3.0-only', d)} \
${@local_license_audit('adwaita-icon-theme-cursors', 'LGPL-3.0-only', d)} \
${@local_license_audit('adwaita-icon-theme-symbolic', 'LGPL-3.0-only', d)} \
${@local_license_audit('adwaita-icon-theme', 'LGPL-3.0-only', d)} \
${@local_license_audit('autoconf', 'GPL-3.0-or-later', d)} \
${@local_license_audit('babl', 'LGPL-3.0-only', d)} \
${@local_license_audit('bash-bashbug', 'GPL-3.0-or-later', d)} \
${@local_license_audit('bash-loadable', 'GPL-3.0-or-later', d)} \
${@local_license_audit('bash', 'GPL-3.0-or-later', d)} \
${@local_license_audit('bc', 'GPL-3.0-or-later', d)} \
${@local_license_audit('binutils', 'GPL-3.0-only', d)} \
${@local_license_audit('bison', 'GPL-3.0-only LGPL-3.0-only', d)} \
${@local_license_audit('blueman', 'GPL-3.0-only', d)} \
${@local_license_audit('bzip2', 'GPL-3.0-or-later', d)} \
${@local_license_audit('cairo-perf-utils', 'GPL-3.0-or-later', d)} \
${@local_license_audit('cairo', 'GPL-3.0-or-later', d)} \
${@local_license_audit('ccache', 'GPL-3.0-or-later', d)} \
${@local_license_audit('cloud-utils', 'GPL-3.0-only', d)} \
${@local_license_audit('colord-gtk', 'LGPL-3.0-only', d)} \
${@local_license_audit('coreutils-stdbuf', 'GPL-3.0-or-later', d)} \
${@local_license_audit('coreutils', 'GPL-3.0-or-later', d)} \
${@local_license_audit('cpio-rmt', 'GPL-3.0-only', d)} \
${@local_license_audit('cpio', 'GPL-3.0-only', d)} \
${@local_license_audit('cpp-symlinks', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('cpp', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('ctdb-tests', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('ctdb', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('debugedit', 'GPL-3.0-only', d)} \
${@local_license_audit('diffutils', 'GPL-3.0-or-later', d)} \
${@local_license_audit('dnsmasq', 'GPL-3.0-only', d)} \
${@local_license_audit('dosfstools', 'GPL-3.0-only', d)} \
${@local_license_audit('elfutils-binutils', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('elfutils', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('enscript', 'GPL-3.0-or-later', d)} \
${@local_license_audit('findutils', 'GPL-3.0-or-later', d)} \
${@local_license_audit('flex', 'GPL-3.0-only LGPL-3.0-only', d)} \
${@local_license_audit('fuse-overlayfs', 'GPL-3.0-or-later', d)} \
${@local_license_audit('g++-symlinks', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('g++', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('g77-symlinks', 'GPL-3.0-only', d)} \
${@local_license_audit('g77', 'GPL-3.0-only', d)} \
${@local_license_audit('gawk-gawkbug', 'GPL-3.0-only', d)} \
${@local_license_audit('gawk', 'GPL-3.0-only', d)} \
${@local_license_audit('gcc-for-nvcc-canadian', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc-for-nvcc-cross', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc-for-nvcc-crosssdk', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc-for-nvcc-runtime', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc-for-nvcc-source', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc-for-nvcc', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc-plugins', 'GPL-3.0-only', d)} \
${@local_license_audit('gcc-symlinks', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcc', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('gcov-symlinks', 'GPL-3.0-only', d)} \
${@local_license_audit('gcov', 'GPL-3.0-only', d)} \
${@local_license_audit('gdb', 'GPL-3.0-only LGPL-3.0-only', d)} \
${@local_license_audit('gdbm-bin', 'GPL-3.0-only', d)} \
${@local_license_audit('gdbm-compat', 'GPL-3.0-only', d)} \
${@local_license_audit('gdbm', 'GPL-3.0-only', d)} \
${@local_license_audit('gdbserver', 'GPL-3.0-only', d)} \
${@local_license_audit('gdbserver', 'LGPL-3.0-only', d)} \
${@local_license_audit('gegl', 'GPL-3.0-only GPL-3.0-or-later', d)} \
${@local_license_audit('gengetopt', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gettext-runtime', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gettext', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gfortran-symlinks', 'GPL-3.0-only', d)} \
${@local_license_audit('gfortran', 'GPL-3.0-only', d)} \
${@local_license_audit('gi-docgen', 'GPL-3.0-or-later', d)} \
${@local_license_audit('glmark2', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gmp', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('gnome-calculator', 'GPL-3.0-only', d)} \
${@local_license_audit('gnome-calendar', 'GPL-3.0-only', d)} \
${@local_license_audit('gnome-flashback', 'GPL-3.0-only', d)} \
${@local_license_audit('gnome-photos', 'GPL-3.0-only', d)} \
${@local_license_audit('gnome-terminal', 'GPL-3.0-only', d)} \
${@local_license_audit('gnome-text-editor', 'GPL-3.0-only', d)} \
${@local_license_audit('gnome-tweaks', 'GPL-3.0-only', d)} \
${@local_license_audit('gnu-config', 'GPL-3.0-with-autoconf-exception', d)} \
${@local_license_audit('gnupg-gpg', 'GPL-3.0-only LGPL-3.0-only', d)} \
${@local_license_audit('gnupg', 'GPL-3.0-only LGPL-3.0-only', d)} \
${@local_license_audit('gnutls-bin', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gnutls-dane', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gnutls-fips', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gnutls-openssl', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gnutls', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gpgme', 'GPL-3.0-or-later', d)} \
${@local_license_audit('gprofng', 'GPL-3.0-only', d)} \
${@local_license_audit('grep', 'GPL-3.0-only', d)} \
${@local_license_audit('groff', 'GPL-3.0-only', d)} \
${@local_license_audit('grub-common', 'GPL-3.0-only', d)} \
${@local_license_audit('grub-editenv', 'GPL-3.0-only', d)} \
${@local_license_audit('grub-efi', 'GPL-3.0-only', d)} \
${@local_license_audit('grub', 'GPL-3.0-only', d)} \
${@local_license_audit('gzip', 'GPL-3.0-or-later', d)} \
${@local_license_audit('idn', 'GPL-3.0-or-later', d)} \
${@local_license_audit('inetutils-ftp', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-ftpd', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-hostname', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-ifconfig', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-inetd', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-logger', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-ping', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-ping6', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-rsh', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-rshd', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-syslogd', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-telnet', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-telnetd', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-tftp', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-tftpd', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils-traceroute', 'GPL-3.0-only', d)} \
${@local_license_audit('inetutils', 'GPL-3.0-only', d)} \
${@local_license_audit('kbd-keymaps-pine', 'GPL-3.0-or-later', d)} \
${@local_license_audit('kbd', 'GPL-3.0-or-later', d)} \
${@local_license_audit('kcolorscheme', 'LGPL-3.0-only', d)} \
${@local_license_audit('kernel-module-vboxguest', 'GPL-3.0-only', d)} \
${@local_license_audit('kernel-module-vboxsf', 'GPL-3.0-only', d)} \
${@local_license_audit('kernel-module-vboxvideo', 'GPL-3.0-only', d)} \
${@local_license_audit('less', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libaddns-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libads-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libasn1util-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libassuan', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libatomic-dev', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libatomic', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libauthkrb5-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libbfd', 'GPL-3.0-only', d)} \
${@local_license_audit('libcdio-paranoia', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libcdio-utils', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libcdio', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libcharset3-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcli-cldap-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcli-ldap-common-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcli-ldap-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcli-nbt-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcli-smb-common-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcliauth-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libclidns-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcloudproviders', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libcluster-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libcommon-auth-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdazzle', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libdbwrap-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdcerpc-binding', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdcerpc-pkt-auth-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdcerpc-samba-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdcerpc-samr', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdcerpc-server-core', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdcerpc', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libdebuginfod', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libelf', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libevents-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libflag-mapping-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libgcc-dev', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libgcc-for-initial', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libgcc-for-nvcc', 'GPL-3.0-only GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libgcc', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libgcrypt', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libgedit-amtk', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libgenrand-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libgensec-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libgettextlib', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libgettextsrc', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libglvnd', 'GPL-3.0-with-autoconf-exception', d)} \
${@local_license_audit('libgomp-dev', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libgomp', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libgse-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libhttp-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libidn', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libidn2-bin', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libidn2', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libidn2', 'LGPL-3.0-only', d)} \
${@local_license_audit('libinterfaces-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libiov-buf-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libkrb5samba-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libksba', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libldb', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libldbsamba-samba4', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libldbsamba-samba4', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('liblibcli-lsa3-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('liblibcli-netlogon3-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('liblibsmb-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libmessages-dgm-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libmessages-util-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libmessaging-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libmessaging-send-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libmpc', 'LGPL-3.0-only', d)} \
${@local_license_audit('libmsghdr-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libmsrpc3-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libndr-krb5pac', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libndr-nbt', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libndr-samba-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libndr-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libndr-standard', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libndr', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libnetapi', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libnetif-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libnetplan', 'GPL-3.0-only', d)} \
${@local_license_audit('libnpa-tstream-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libopcodes', 'GPL-3.0-only', d)} \
${@local_license_audit('libpipeline', 'GPL-3.0-only', d)} \
${@local_license_audit('libportal', 'LGPL-3.0-only', d)} \
${@local_license_audit('librelp', 'GPL-3.0-only', d)} \
${@local_license_audit('libreplace-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-cluster-support-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-credentials', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-debug-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-errors', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-hostconfig', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-modules-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-net-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-passdb', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-policy', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-python-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-security-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-sockets-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba-util', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamba3-util-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamdb-common-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsamdb', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsecrets3-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libserialport', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libserver-id-db-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libserver-role-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsigc++-3', 'LGPL-3.0-only', d)} \
${@local_license_audit('libsmb-transport-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsmbclient-raw-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsmbclient', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsmbconf', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsmbd-shim-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsmbldap', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libsocket-blocking-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libstable-sort-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libstdc++-dev', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libstdc++', 'GPL-3.0-with-GCC-exception', d)} \
${@local_license_audit('libsys-rw-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtalloc-report-printf-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtalloc', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtasn1-bin', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libtasn1', 'GPL-3.0-or-later', d)} \
${@local_license_audit('libtdb-wrap-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtdb', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtevent-util', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtevent', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libtime-basic-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libtrusts-util-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libunistring', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libutil-cmdline-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libutil-reg-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libutil-setid-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libutil-tdb-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libvte-gtk4', 'GPL-3.0-only LGPL-3.0-or-later', d)} \
${@local_license_audit('libvte', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('libwbclient', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('libwinbind-client-samba4', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('lxdm', 'GPL-3.0-only', d)} \
${@local_license_audit('m4', 'GPL-3.0-only', d)} \
${@local_license_audit('make', 'GPL-3.0-only', d)} \
${@local_license_audit('man-db', 'GPL-3.0-or-later', d)} \
${@local_license_audit('mc-fish', 'GPL-3.0-only', d)} \
${@local_license_audit('mc-helpers-perl', 'GPL-3.0-only', d)} \
${@local_license_audit('mc-helpers', 'GPL-3.0-only', d)} \
${@local_license_audit('mc', 'GPL-3.0-only', d)} \
${@local_license_audit('menulibre', 'GPL-3.0-only', d)} \
${@local_license_audit('mokutil', 'GPL-3.0-only', d)} \
${@local_license_audit('monit', 'AGPL-3.0-only', d)} \
${@local_license_audit('mosh', 'GPL-3.0-or-later', d)} \
${@local_license_audit('mpfr', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('mtools', 'GPL-3.0-only', d)} \
${@local_license_audit('musl-locales', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('nautilus', 'GPL-3.0-only', d)} \
${@local_license_audit('netplan-dbus', 'GPL-3.0-only', d)} \
${@local_license_audit('netplan', 'GPL-3.0-only', d)} \
${@local_license_audit('nettle', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('oci-systemd-hook', 'GPL-3.0-only', d)} \
${@local_license_audit('openbox-xdgmenu', 'GPL-3.0-or-later', d)} \
${@local_license_audit('parted', 'GPL-3.0-or-later', d)} \
${@local_license_audit('patch', 'GPL-3.0-only', d)} \
${@local_license_audit('poke', 'GPL-3.0-or-later', d)} \
${@local_license_audit('poppler-data', 'GPL-3.0-or-later', d)} \
${@local_license_audit('pyldb', 'GPL-3.0-or-later', d)} \
${@local_license_audit('pyldb', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('pytalloc', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('python3-dbusmock', 'GPL-3.0-only', d)} \
${@local_license_audit('python3-docutils', 'GPL-3.0-only', d)} \
${@local_license_audit('python3-rfc3987', 'GPL-3.0-or-later', d)} \
${@local_license_audit('python3-strict-rfc3339', 'GPL-3.0-only', d)} \
${@local_license_audit('python3-tdb', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('python3-tevent', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('qqc2-desktop-style', 'LGPL-3.0-only', d)} \
${@local_license_audit('readline', 'GPL-3.0-or-later', d)} \
${@local_license_audit('registry-tools', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('rsync', 'GPL-3.0-or-later', d)} \
${@local_license_audit('rsyslog', 'GPL-3.0-only LGPL-3.0-only', d)} \
${@local_license_audit('rxvt-unicode', 'GPL-3.0-only', d)} \
${@local_license_audit('samba-ad-dc', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-base', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-client', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-common', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-dsdb-modules', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-pidl', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-python3', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-server', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-test', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba-testsuite', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('samba', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('screen', 'GPL-3.0-or-later', d)} \
${@local_license_audit('seabios', 'LGPL-3.0-only', d)} \
${@local_license_audit('sed', 'GPL-3.0-or-later', d)} \
${@local_license_audit('sharutils', 'GPL-3.0-or-later', d)} \
${@local_license_audit('smbclient', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('tar-rmt', 'GPL-3.0-only', d)} \
${@local_license_audit('tar', 'GPL-3.0-only', d)} \
${@local_license_audit('tdb-tools', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('tepl', 'LGPL-3.0-or-later', d)} \
${@local_license_audit('texinfo', 'GPL-3.0-or-later', d)} \
${@local_license_audit('time', 'GPL-3.0-only', d)} \
${@local_license_audit('vboxguestdrivers', 'GPL-3.0-only', d)} \
${@local_license_audit('vte-gtk4', 'GPL-3.0-only LGPL-3.0-or-later', d)} \
${@local_license_audit('vte-prompt', 'GPL-3.0-only LGPL-3.0-or-later', d)} \
${@local_license_audit('vte', 'GPL-3.0-only LGPL-3.0-or-later', d)} \
${@local_license_audit('wget', 'GPL-3.0-only', d)} \
${@local_license_audit('which', 'GPL-3.0-or-later', d)} \
${@local_license_audit('winbind', 'GPL-3.0-or-later LGPL-3.0-or-later', d)} \
${@local_license_audit('xfce-dusk-gtk3', 'GPL-3.0-only', d)} \
${@local_license_audit('xfce4-panel-profiles', 'GPL-3.0-only', d)} \
${@local_license_audit('zeromq', 'LGPL-3.0-or-later', d)} \
"

# ---
