# conf/distro/include/distro-rust.inc

RUST_VERSION = "1.75.0"

# require conf/distro/include/rust_security_flags.inc
require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'rust-layer', 'conf/distro/include/rust_versions.inc', '', d)}

# ---
