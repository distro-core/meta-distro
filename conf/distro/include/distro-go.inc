# conf/distro/include/distro-go.inc

# Used to define alternative go version

GO_VERSION = "1.22.12"
# export GOPROXY = "direct"

PREFERRED_VERSION_go = "${GO_VERSION}"
PREFERRED_VERSION_go-binary-native = "${GO_VERSION}"
PREFERRED_VERSION_go-cross = "${GO_VERSION}"
PREFERRED_VERSION_go-cross-canadian = "${GO_VERSION}"
PREFERRED_VERSION_go-crosssdk = "${GO_VERSION}"
PREFERRED_VERSION_go-runtime = "${GO_VERSION}"
PREFERRED_VERSION_virtual/${TUNE_PKGARCH}-go ="${GO_VERSION}"

# ---
