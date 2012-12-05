#!/bin/bash
#
# anrxc's X.org init file on Arch GNU/Linux

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi


# {{{ Environment settings
errorlog="${HOME}/.xsession-errors"
gnupglog="${HOME}/.gnupg/gpg-agent.env"
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
xrandr --dpi 96
# Force LVDS as the primary screen
xrandr --output LVDS-1 --primary --auto
if (xrandr -q | grep -u "VGA-1 connected" ); then
	xrandr --output VGA-1 --right-of LVDS-1 --auto
fi
# }}}

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
xset r rate 200 30

# Pointer control, acceleration and threshold
xset m 30/10 4

# Pointer appearance
#   - xcb does not support Xcursor yet
xsetroot -cursor_name left_ptr

# Fix the broken udev keymap
#  - Lock, Presentation, Sync, €, $
#        sudo /usr/bin/setkeycodes e06e 152
#        sudo /usr/bin/setkeycodes e075 217
#        sudo /usr/bin/setkeycodes e079 173
#        sudo /usr/bin/setkeycodes e033 159
#        sudo /usr/bin/setkeycodes e034 151
# }}}

# {{{ Font Settings
#xset +fp /usr/share/fonts/local
#xset fp rehash
# }}}

# {{{ Autostart settings
#
# Start the GnuPG agent and enable OpenSSH agent emulation
if (pgrep -u "${USER}" gpg-agent); then
	eval `cat ${gnupglog}`
	eval `cut -d= -f1 ${gnupglog} | xargs echo export`
else
	eval `gpg-agent --enable-ssh-support --daemon`
fi

# Start the URXVT daemon
urxvtd -q -o -f &
# Start the GNU Emacs daemon
[[ ! -r "/tmp/emacs${UID}/server" ]] && emacs --daemon &


nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1"
nvidia-settings -a InitialPixmapPlacement=2
# Start the device monitor
#devmon &

# Xwrits reminds you to take wrist breaks and avoid RSI
#            xwrits typetime=45 clock breakclock top ready-picture="${HOME}/.xwrits/ready.gif" \
	#           rest-picture="${HOME}/.xwrits/rest.gif" warning-picture="${HOME}/.xwrits/warning.gif" &

# Open a terminal emulator on the first tag
#   - resume the old screen session or start a new one
#urxvt -e byobu -u -2  &

#synclient PalmDetect=1 &
# Start the virtual box client
#            /usr/bin/VBoxClient-all
# Play a startup sound
#            ogg123 -q "${HOME}/.local/share/gajim/sounds/voices/voice-system-activated.ogg" &
# }}}

# {{{ Window manager selection
case "$WM" in
	twm)
		exec twm
		;;
	fvwm)
		exec fvwm2
		;;
	kde)
		exec startkde
		;;
	debug)
		exec valgrind -v "$1"
		;;
	gnome)
		exec gnome-session 
		;;
	awesome)
		exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
		;;
	console)
		exec urxvt -T console -e /bin/zsh
		;;
	*)
		exec awesome -c ~/.config/awesome/rc.lua >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
		;;
esac
# }}}
