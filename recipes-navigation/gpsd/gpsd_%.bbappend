FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
	sed -i -e 's#GPS_DEVICES=""#GPS_DEVICES="/dev/ttyACM0"#g' ${D}/${sysconfdir}/default/gpsd.default
	sed -i -e 's*. /lib/init/vars.sh*#. /lib/init/vars.sh*g' ${D}/${sysconfdir}/init.d/gpsd
	sed -i -e 's*. /lib/lsb/init-functions*#. /lib/lsb/init-functions*g' ${D}/${sysconfdir}/init.d/gpsd
}
