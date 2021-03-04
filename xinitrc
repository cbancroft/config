#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi
# Uncomment if you're using gtk3-nocsd instead of gtk3-mushrooms
#export GTK_CSD=0
#export LD_PRELOAD=/lib/libgtk3-nocsd.so.0

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


# Start the device monitor
udiskie &

export VISUAL="nvim"
export EDITOR="nvim"

export BROWSER="firefox"

export TERM="xterm-kitty"

export PATH=${PATH}:${HOME}/.local/bin

# Enable hidden scrollbars if using  gtk3-mushrooms
#export GTK_OVERLAY_SCROLLING=1

RANGER_LOAD_DEFAULT_RC=FALSE

export QT_QPA_PLATFORMTHEME=qt5ct

# Don't minimize SDL games on focus loss
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

# Set Java Environment
#archlinux-java set java-13-openjdk
#wmname LG3D
#export _JAVA_AWT_WM_NONREPARENTING=1

source /usr/share/nvm/init-nvm.sh
nvm use --silent stable
