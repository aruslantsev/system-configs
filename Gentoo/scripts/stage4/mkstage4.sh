mount -o bind / /mnt
mount -o bind /boot /mnt/boot
cd /mnt/
tar -cpP --xattrs --xattrs-include='*.*' --numeric-owner --checkpoint=10000 --selinux -jf ~/stage4-$(arch)-$(hostname)-$(date +%Y%m%d).tar.bz2 -X ~/stage4.excl .
cd
umount /mnt/boot
umount /mnt
