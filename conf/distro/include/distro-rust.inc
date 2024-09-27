# conf/distro/include/distro-rust.inc

require ${@bb.utils.contains('BBFILE_COLLECTIONS', 'rust-layer', 'conf/distro/include/rust_versions.inc', '', d)}

# ---
