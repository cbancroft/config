#!/bin/bash
# nvidia -> nouveau

sed -i 's/#*options nouveau modeset=1/options nouveau modeset=1/' /etc/modprobe.d/modprobe.conf
sed -i 's/#*MODULES="nouveau"/MODULES="nouveau"/' /etc/mkinitcpio.conf

pacman -Rdds --noconfirm nvidia{,-utils} lib32-nvidia-utils
pacman -S --noconfirm nouveau-dri xf86-video-nouveau lib32-libgl

#cp {10-monitor,20-nouveau}.conf /etc/X11/xorg.conf.d/

mkinitcpio -p linux
