#!/bin/bash

#This script enables my 2 external screens and disables my laptop display
xrandr --output LVDS-1 --off 
xrandr --output DP-1 --pos 0x0 --auto --primary --output DP-2 --auto --right-of DP-1
