#! /usr/bin/env sh

# A hyprland script for a laptop-external-monitor setup, toggling between which is in use

# Launch at startup to make hyprland disable the internal monitor if an external monitor is detected and enabled
# Additionally it's called with a keybind to switch between a laptop monitor and an external display
# Ideally the conditional monitor behaviour was instead done directly in hyprland.conf, but I'm not sure whether that's possible
#
# Relevant info:
# - hyprctl monitors: identifies currently enabled monitors
# - hyprctl monitors all: identifies ALL connected monitors - including those not in use
#
# Suggested use:
# Add this line somewhere after the regular monitor configuration in hyprland.conf:
# exec = /path/to/hyprland-monitors-toggle.sh
# Add a keybind to run this script on demand:
# bind =,SomeKeyHere, exec, /path/to/hyprland-monitors-toggle.sh

# TODO: Detect these instead of hardcoding them
INTERNAL_MONITOR="eDP-1"


# Turn off the laptop monitor if the lid is closed
if grep open /proc/acpi/button/lid/LID0/state; then
    hyprctl keyword monitor "${INTERNAL_MONITOR}, 1920x1080@60, 0x0, 1"
else
    if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
        hyprctl keyword monitor "${INTERNAL_MONITOR}, disable"
    fi
fi

