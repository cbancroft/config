#!/bin/bash
echo `gtf $2 $3 60 | grep Modeline | sed s/Modeline\ // | tr -d '"'`
xrandr --newmode $(gtf $2 $3 59.99 | grep Modeline | sed s/Modeline\ // | tr -d '"')
xrandr --addmode $1 ${2}x${3}_60.00
