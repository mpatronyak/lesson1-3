#!/bin/bash

# Удаляем физический том
lvremove -f /dev/vg_root/lv_root
vgremove -f /dev/vg_root
pvremove -f /dev/sdb
#Выделяем том под /home
lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home
mount /dev/VolGroup00/LogVol_Home /mnt
cp -aR /home/* /mnt
rm -rf /home/*
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab

touch /home/file{1..20}
#Снимаем снапшот
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
rm -f /home/file{11..20}
#Процесс восстановления из снапшота
umount /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home


