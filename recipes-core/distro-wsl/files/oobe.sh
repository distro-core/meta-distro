#!/bin/bash -ue

set -ue

echo ""
echo "Provisioning for %DISTRO%-%DISTRO_VERSION% hardcoded default user $(id %WSL_USER_NAME%)"
echo ""

# setx.exe GNUPGHOME '%USERPROFILE%\.gnupg'
# setx.exe WSLENV 'USERNAME:USERPROFILE/p'

# systemctl disable apparmor.socket
# systemctl disable apparmor.service

read -p "Press ENTER to continue." value

exit 0

DEFAULT_UID="1000"
DEFAULT_GROUPS="adm,cdrom,sudo,dip,plugdev"

echo "Please create a default UNIX user account. The username does not need to match your Windows username."
echo "For more information visit: https://aka.ms/wslusers"

if getent passwd "$DEFAULT_UID" > /dev/null ; then
  echo "User account already exists, skipping creation"
  exit 0
fi

while true; do
    read -p "Enter new UNIX username: " username
    if /usr/sbin/adduser --uid "$DEFAULT_UID" --quiet --gecos ""  "$username"; then
        if /usr/sbin/usermod "$username" -aG "$DEFAULT_GROUPS"; then
            break
        else
            /usr/sbin/deluser "$username"
        fi
    fi
done
