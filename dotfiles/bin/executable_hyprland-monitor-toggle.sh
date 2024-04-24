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
EXTERNAL_MONITOR="DP-3"

NUM_MONITORS=$(hyprctl monitors all | grep Monitor | wc --lines)
NUM_MONITORS_ACTIVE=$(hyprctl monitors | grep Monitor | wc --lines)


# Turn off the laptop monitor if its on + more than one monitor is active
# This is currently the case on startup if you use hyprland's default monitor settings
if [ $NUM_MONITORS_ACTIVE -gt 1 ] && hyprctl monitors | grep --quiet $INTERNAL_MONITOR; then
    hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
    exit
fi

if [ $NUM_MONITORS -gt 1 ]; then  # Don't do anything if only a single monitor is detected

  if hyprctl monitors | grep --quiet $EXTERNAL_MONITOR; then
    hyprctl keyword monitor "$EXTERNAL_MONITOR, disable"
    hyprctl keyword monitor "$INTERNAL_MONITOR, preferred, 0, auto"
  else
    hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
    hyprctl keyword monitor "$EXTERNAL_MONITOR, preferred, 0, auto"
  fi
fi
