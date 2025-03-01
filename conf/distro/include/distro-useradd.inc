# conf/distro/include/distro-useradd.inc

# Used to define group and passwd mappings

# static gids
USERADD_GID_TABLES += "files/static-group"

# static uids
USERADD_UID_TABLES += "files/static-passwd"

# if "useradd-staticids", dynamic useradd will check against static lists
USERADDEXTENSION = "useradd-staticids"

# if "error", dynamic useradd generate error if not in static lists
USERADD_ERROR_DYNAMIC = "error"

# ---
