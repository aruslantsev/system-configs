dracut --uefi --no-hostonly --kver ${KVER}
mv /boot/EFI/Linux/linux-${KVER}-*.efi /boot/linux-${KVER}.efi.orig
cd /boot
sbsign --key ~/secureboot/db.key --cert ~/secureboot/db.crt --output /boot/linux-${KVER}.efi /boot/linux-${KVER}.efi.orig
gpg --batch --detach-sign linux-${KVER}.efi
