#!/bin/bash
# nouveau -> nvidia

set -e

# check if root
if [[ $EUID -ne 0 ]]; then
    echo "You must be root to run this script. Aborting...";
    exit 1;
fi

sed -i 's/MODULES="nouveau"/#MODULES="nouveau"/' /etc/mkinitcpio.conf

pacman -Rdds --noconfirm nouveau-dri xf86-video-nouveau mesa-libgl lib32-nouveau-dri lib32-mesa-libgl
pacman -S --noconfirm nvidia{,-utils} lib32-nvidia-utils

mkinitcpio -p linux
