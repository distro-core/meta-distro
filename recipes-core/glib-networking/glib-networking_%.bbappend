PACKAGECONFIG = "gnutls environment ${@bb.utils.contains('PTEST_ENABLED', '1', 'tests', '', d)}"
