#!/bin/bash

lvremove -f /dev/VolGroup00/LogVol00
lvcreate -W y -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00 --yes
mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt
xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt bash /vagrant/chroot_command_var.sh










