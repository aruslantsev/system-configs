if [ -z "${1}" ]; then
	echo "Usage: ${0} KVER"
	exit 1
fi

if [ $(whoami) != 'root' ]; then
	echo "You are not root"
	exit 1
fi

KVER="${1}"
dracut --kver ${KVER} \
	&& mv /boot/EFI/Linux/linux-${KVER}-*.efi /boot/linux-${KVER}.efi.orig \
	&& cd /boot \
	&& sbsign --key ~/secureboot/db.key --cert ~/secureboot/db.crt --output linux-${KVER}.efi linux-${KVER}.efi.orig \
	&& gpg --detach-sign linux-${KVER}.efi \
	&& echo "Success" || echo "Failed"
