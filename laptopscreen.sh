#!/bin/bash

#This script disables my 2 external screens and enables my laptop display
xrandr --output DP-1 --off --output DP-2 --off
xrandr --output LVDS-1 --auto --primary --pos 0x0
