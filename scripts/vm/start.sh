source ./env

if [ -z "${DRIVE_NAME}" ]
then
	echo "Missing DRIVE_NAME in ./env"
	exit 1
fi

if [ ! -f "${DRIVE_NAME}" ]
then
	echo "Image ${DRIVE_NAME} is missing. Create? (y/n)"
	read ANS
	if [ "${ANS}" != "y" ]
	then
		echo "Can't run without disk"
		exit
	fi
	echo "Creating image. Enter the size"
	read SIZE
	qemu-img create -f qcow2 ${DRIVE_NAME} ${SIZE} || exit 1
fi

if [ ! -z "${USB}" ] && [ "${USB}" -ne 0 ]
then
	USB_CMD="-usb -device usb-mouse -device usb-kbd"
else
	USB_CMD=""
fi

if [ ! -z "${UEFI}" ] && [ "${UEFI}" -ne 0 ]
then
	if [ ! -f OVMF_VARS.fd ]
	then
		cp /usr/share/edk2-ovmf/OVMF_VARS.fd OVMF_VARS.fd
	fi
	UEFI_CMD="-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/OVMF_CODE.fd -drive if=pflash,format=raw,file=OVMF_VARS.fd"
else
	UEFI_CMD=""
fi

if [ ! -z "${VNC_PORT}" ]
then
	VNC_CMD="-vnc :${VNC_PORT} -monitor stdio"
else
	VNC_CMD=""
fi

NET_CMD="-nic user"
if [ ! -z "${SSH_PORT}" ]
then
	NET_CMD="${NET_CMD},hostfwd=tcp::${SSH_PORT}-:22"
fi
if [ ! -z "${SAMBA_PATH}" ]
then
	NET_CMD="${NET_CMD},smb=${SAMBA_PATH}"
fi

if [ -z "${EXTRA_CMD}" ]
then
	EXTRA_CMD=""
fi

CMD="qemu-system-x86_64 \
-name \"${VM_NAME}\" \
-enable-kvm -machine q35,accel=kvm -device intel-iommu \
-m ${VM_MEMORY} \
-cpu host -smp ${CPU_NUM} \
-drive file=${DRIVE_NAME} \
${USB_CMD} \
${UEFI_CMD} \
-vga std \
-device intel-hda \
-audiodev pa,id=snd0 -device hda-output,audiodev=snd0 \
${NET_CMD} \
${VNC_CMD} \
${EXTRA_CMD} \
$@ \
"

echo $CMD

$CMD
