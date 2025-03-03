#!/bin/sh

# Not a true unlock. Modem initialization.

# require program name and at least 2 arguments
[ $# -lt 2 ] && exit 1

# first argument is DBus path, not needed here
shift

# second and next arguments are control port names
for PORT in "$@"; do
  # match port name
  echo "$PORT" | grep -q cdc-wdm && {
    CDC_WDM_PORT=$PORT
    break
  }
done

# fail if no cdc-wdm port exposed
[ -n "$CDC_WDM_PORT" ] || exit 2

# output=$(expect <<EOF
# set timeout 5
# log_user 0
# spawn screen /dev/ttyUSB0 -
# sleep 1
# send "AT\x5ECHIPTEMP?\r"
# expect "OK"
# puts "\n-->\$expect_out(buffer)<--"
# # Send C-a \ to end the session
# send "\x01"
# send "\x5C"
# EOF
# )
# Strip non-printable control characters
# output=$(printf "$output" | tr -dc '[:print:]\n' )
# printf "$output\n" | grep -P "^\^CHIPTEMP"

# run qmicli operation
# qmicli --device-open-proxy --device="/dev/$CDC_WDM_PORT" --dms-set-fcc-authentication
# exit $?

exit 0
