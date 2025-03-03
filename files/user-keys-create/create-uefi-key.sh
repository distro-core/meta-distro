#!/bin/sh

[[ -z "$(command -v openssl)" ]] && echo "requires openssl" && exit 0
[[ -z "$(command -v sbsiglist)" ]] && echo "requires sbsigntools" && exit 0

# generate keys with create-user-key-store

uuid=$(systemd-id128 new --uuid)
for key in PK KEK db dbx; do
    echo "create key: ${key}"
    # openssl req -new -x509 -subj "/CN=${key}/" -keyout "${key}.key" -out "${key}.crt"
    openssl x509 -outform DER -in "${key}.crt" -out "${key}.der"
    sbsiglist --owner "${uuid}" --type x509 --output "${key}.esl" "${key}.der"
done

# See also: Windows Secure Boot Key Creation and Management Guidance
# https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-secure-boot-key-creation-and-management-guidance?view=windows-11
curl --location \
    "https://go.microsoft.com/fwlink/p/?linkid=321192" -o ms-db-2011.der \
    "https://go.microsoft.com/fwlink/p/?linkid=321185" -o ms-kek-2011.der \
    "https://go.microsoft.com/fwlink/p/?linkid=321194" -o ms-uefi-db-2011.der \
    "https://go.microsoft.com/fwlink/p/?linkid=2239776" -o ms-db-2023.der \
    "https://go.microsoft.com/fwlink/p/?linkid=2239775" -o ms-kek-2023.der \
    "https://go.microsoft.com/fwlink/p/?linkid=2239872" -o ms-uefi-db-2023.der
sha1sum -c <<END
580a6f4cc4e4b669b9ebdc1b2b3e087b80d0678d  ms-db-2011.der
31590bfd89c9d74ed087dfac66334b3931254b30  ms-kek-2011.der
46def63b5ce61cf8ba0de2e6639c1019d0ed14f3  ms-uefi-db-2011.der
45a0fa32604773c82433c3b7d59e7466b3ac0c67  ms-db-2023.der
459ab6fb5e284d272d5e3e6abc8ed663829d632b  ms-kek-2023.der
b5eeb4a6706048073f0ed296e7f580a790b59eaa  ms-uefi-db-2023.der
END
for key in ms-*.der; do
    sbsiglist --owner 77fa9abd-0359-4d32-bd60-28f4e78f784b --type x509 --output "${key%der}esl" "${key}"
done

# Optionally add Microsoft Windows certificates (needed to boot into Windows).
# cat ms-db-*.esl >>db.esl

# Optionally add Microsoft UEFI certificates for firmware drivers / option ROMs and third-party
# boot loaders (including shim). This is highly recommended on real hardware as not including this
# may soft-brick your device (see next paragraph).
cat ms-uefi-*.esl >>db.esl

# Optionally add Microsoft KEK certificates. Recommended if either of the Microsoft keys is used as
# the official UEFI revocation database is signed with this key. The revocation database can be
# updated with fwupdmgr(1).
cat ms-kek-*.esl >>KEK.esl

attr=NON_VOLATILE,RUNTIME_ACCESS,BOOTSERVICE_ACCESS,TIME_BASED_AUTHENTICATED_WRITE_ACCESS
echo "sbvarsign: PK w/PK"
sbvarsign --attr "${attr}" --key PK.key --cert PK.crt --output PK.auth PK PK.esl
echo "sbvarsign: KEK w/PK"
sbvarsign --attr "${attr}" --key PK.key --cert PK.crt --output KEK.auth KEK KEK.esl
echo "sbvarsign: db w/KEK"
sbvarsign --attr "${attr}" --key KEK.key --cert KEK.crt --output db.auth db db.esl
echo "sbvarsign: dbx w/KEK"
sbvarsign --attr "${attr}" --key KEK.key --cert KEK.crt --output dbx.auth dbx dbx.esl

rm -f ms-*.der ms-*.esl
