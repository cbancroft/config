#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto

# {{{ Environment settings
errorlog="${HOME}/.xsession-errors"
tmuxSession="asshai"
# }}}


# {{{ Log settings
#
# Always start X11 with a clean log file
if (cp /dev/null "${errorlog}"); then
	chmod 600 "${errorlog}"
	exec >"${errorlog}" 2>&1
fi
# }}}


# {{{ Display settings
#
# Ignore reported display size and force DPI
#xrandr --dpi 144

# {{{ Resource and keymap settings
usermodmap="${HOME}/.Xmodmap"
userresources="${HOME}/.Xresources"
sysmodmap="/etc/X11/xinit/.Xmodmap"
sysresources="/etc/X11/xinit/.Xresources"

# Merge system and user resources and keymaps
[[ -r "${sysresources}" ]]  && xrdb -merge "${sysresources}"
[[ -r "${sysmodmap}" ]]     && xmodmap "${sysmodmap}"
[[ -r "${userresources}" ]] && xrdb -merge "${userresources}"
[[ -r "${usermodmap}" ]]    && xmodmap "${usermodmap}"
# }}}


# {{{ Input settings
# 
# Keyboard control, repeat delay and repeat rate
#xset r rate 200 30

# Pointer control, acceleration and threshold
#xset m 30/10 4 &



# {{{ Font Settings
#xset +fp /usr/share/fonts/local
#xset fp rehash &
# }}}

# {{{ Autostart settings
#
# Start the URXVT daemon
#urxvtd -q -o -f &

# Start the GNU Emacs daemon
#[[ ! -r "/tmp/emacs${UID}/server" ]] && emacs --daemon &

#nvidia-settings -a InitialPixmapPlacement=2
#nvidia-settings -a InitialPixmapPlacement=0
#compton -b --paint-on-overlay --unredir-if-possible --backend xr_glx_hybrid --vsync drm --glx-swap-method -1 --glx-no-stencil
#compton -cCG -o 0.75 -f 0.05 -t 0.01 -l -2 -r 2.5  -i 0.8 &
# compton &
# Start the device monitor
udiskie &

# Open a terminal emulator on the first tag
#   - resume the old screen session or start a new one
#tmux has-session -t $tmuxSession || tmux new -d -s $tmuxSession 
#termite -e "zsh -c tmux attach -t $tmuxSession" &

# synclient PalmDetect=1 PalmMinWidth=3 &

# synclient TouchpadOff=1 &
# Disable the touchpad
#xinput set-prop 20 153 0

# wmname LG3D
# Play a startup sound
#            ogg123 -q "${HOME}/.local/share/gajim/sounds/voices/voice-system-activated.ogg" &
# }}}

# {{{ Window manager selection
#case "$WM" in
#	twm)
#		exec twm
#		;;
#	fvwm)
#		exec fvwm2
#		;;
##	kde)
#		exec startkde
#		;;
#	debug)
#		exec valgrind -v "$1"
#		;;
#	gnome)
#		exec gnome-session 
#		;;
#	awesome)
#		exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
#		;;
#	console)
#		exec urxvt -T console -e /bin/zsh
#		;;
#	*)
#       exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
#		;;
#esac
# }}}
# autorandr -c &