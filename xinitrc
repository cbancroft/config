#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Start the virtual box client
/usr/bin/VBoxClient-all &

# {{{ Environment settings
errorlog="${HOME}/.xsession-errors"
gnupglog="${HOME}/.gnupg/gpg-agent.env"
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
xset m 30/10 4 &



# {{{ Font Settings
#xset +fp /usr/share/fonts/local
xset fp rehash &
# }}}

# {{{ Autostart settings
#
# Start the GnuPG agent and enable OpenSSH agent emulation
if (pgrep -u "${USER}" gpg-agent); then
	eval `cat ${gnupglog}`
	eval `cut -d= -f1 ${gnupglog} | xargs echo export`
else
	eval `gpg-agent --enable-ssh-support --daemon --write-env-file ${gnupglog}`
fi
gpg-connect-agent updatestartuptty /bye

# Start the URXVT daemon
#urxvtd -q -o -f &

# Start the GNU Emacs daemon
[[ ! -r "/tmp/emacs${UID}/server" ]] && emacs --daemon &

#nvidia-settings -a InitialPixmapPlacement=2
#nvidia-settings -a InitialPixmapPlacement=0
#compton -cCG -o 0.75 -f 0.05 -t 0.01 -l -2 -r 2.5  -i 0.8 &
#compton &
# Start the device monitor
devmon &

# Open a terminal emulator on the first tag
#   - resume the old screen session or start a new one
tmux has-session -t $tmuxSession || tmux new -d -s $tmuxSession 
termite -e "zsh -c tmux attach -t $tmuxSession" &

synclient PalmDetect=1 PalmMinWidth=3 &

dropboxd &
#synclient TouchpadOff=1 &
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
autorandr -c &
