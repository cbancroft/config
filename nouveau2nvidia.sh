#!/bin/bash
# nouveau -> nvidia

sed -i 's/options nouveau modeset=1/#options nouveau modeset=1/' /etc/modprobe.d/modprobe.conf
sed -i 's/MODULES="nouveau"/#MODULES="nouveau"/' /etc/mkinitcpio.conf

pacman -Rdds --noconfirm nouveau-dri xf86-video-nouveau libgl lib32-libgl
pacman -S --noconfirm nvidia{,-utils} lib32-nvidia-utils

#rm /etc/X11/xorg.conf.d/{10-monitor,20-nouveau}.conf

mkinitcpio -p linux
