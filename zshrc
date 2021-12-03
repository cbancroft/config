# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -*- shell-script -*-
#
# cbancroft's init file for Z-SHELL 4.3.10 on Arch GNU/Linux
# Modified from anxrc's .zshrc
export LANG="en_US.UTF-8"
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
POWERLINE_DETECT_SSH="true"
if [ "${TERM}" = "linux" ]; then
    ZSH_THEME="random"
else
    #ZSH_THEME="powerlevel9k/powerlevel9k"
    #ZSH_THEME="powerline"
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(gitfast git-extras ubuntu battery fzf docker gpg-agent)

source $ZSH/oh-my-zsh.sh

#source /etc/profile.d/infinality-settings.sh
#source /etc/profile.d/freetype2.sh
#xrdb -merge ~/.Xdefaults
# {{{ User Settings

# {{{ zle configuration
bindkey "\e[7~" beginning-of-line	#Home
bindkey "\e[8~" end-of-line		#End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
bindkey "\e[3^" delete-word
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[4~" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line


# }}}

# {{{ Dircolors
#       - with rxvt-256color support
# eval `dircolors -b "${HOME}/.dir_colors"`
# }}}

# {{{ Man Pages
#       - colorize, since man-db fails to do so
#export LESS_TERMCAP_mb=$'\E[01;31m'     #begin blinking
#export LESS_TERMCAP_md=$'\E[01;31m'     #begin bold
#export LESS_TERMCAP_me=$'\E[0m'         #end mode
#export LESS_TERMCAP_se=$'\E[0m'         #end standout mode
#export LESS_TERMCAP_so=$'\E[1;33;40m'   #begin standout-mode - info box
#export LESS_TERMCAP_ue=$'\E[0m'         #end underline
#export LESS_TERMCAP_us=$'\E[1;32m'      #begin underline
# }}}

# {{{ Aliases
alias ..="cd .."
alias ...="cd ../.."

alias ls="ls -aFF --color=always"
alias ll="ls -l"
alias lfi="ls -l | egrep -v '^d'"
alias ldi="ls -l | egrep '^d'"
alias lst="ls -htl | grep `date +%Y-%m-%d`"
alias grep="grep --color=always"
alias cp="cp -ia"
alias mv="mv -i"
alias rm="rm -I"
alias cls="clear"
alias upmem="ps -eo pmem,pcpu,rss,vsize,args | sort -k 1"
alias top="htop"
alias psg="ps auxw | grep -i "
alias psptree="ps auxwwwf"
alias df="df -hT"
alias du="du -hc"
alias dus="du -S | sort -n"
alias free="free -m"
alias su="su - "
alias x="startx &! logout"
alias rehash="hash -r"
alias eject="eject -v"
alias retract="eject -t -v"
alias vuser="fuser -v"
alias ping="ping -c 5"
alias more="less"
alias mc=". /usr/lib/mc/mc-wrapper.sh -x"
alias links="links ${HOME}/.links/startpage.html"
alias cplay="cplay -v"
alias xtr="extract"
alias sat="date +%R"
alias bat="acpitool -b"
alias calc="bc -l <<<"
alias iodrag="ionice -c3 nice -n19"
alias pandora="pianobar"
alias spell="aspell -a <<< "
alias ec="emacsclient -a emacs -n "
alias ect="emacsclient -a emacs -t "
alias gpgd="gpg2 --decrypt"
alias gpge='gpg2 -ear "cbancroft@bbn.com"'
alias passgen="< /dev/urandom tr -cd \[:graph:\] | fold -w32 | head -n 5"
alias keyshare="synergys -f --config /etc/synergy.conf"
alias xpop="xprop | grep --color=none 'WM_CLASS\|^WM_NAME' |  xmessage -file -"
alias deternet="ssh -X cbancrof@${DETERNET}"
alias deterlab="ssh cbancrof@${DETERLAB}"
alias bbnvpn="ssh -D 8080 -f -C -q -N cbancrof@ssh.bbn.com && export IMAP_SERVER=localhost:8143"
alias daytona="cd ~/work/daytona/DAYTONA-current"
alias school="cd ~/git/school"
alias cleandock='docker rm $(docker ps -a -q -f status=exited)'
alias ppjson="python3 -m json.tool"

# {{{ Daytona nodes
alias dbuild="ssh -A -l cbancroft build.daytona.ir.bbn.com"
# }}}

# {{{ CQF commands
alias cqf="cd ~/work/cqf"
alias cqfbuild="cqf && ./mvnw clean install -DskipTests"
alias cqfdist="cqf && ./mvnw clean install"
alias cqfweb="cqf && cd cqf-portal && yarn start"
# }}}

# {{{ Auto Extension Stuff
alias -s html=${BROWSER}
alias -s png=feh
alias -s jpg=feh
alias -s cpp=${EDITOR}
alias -s pdf=xpdf
alias -s txt=${EDITOR}
alias -s ppt=libreoffice
alias -s pptx=libreoffice
alias -s doc=libreoffice
alias -s docx=libreoffice
# }}}

# {{{ Slurpy
alias aurup="slurpy -c -u -d"               # Sync, Update & Download
alias aurlu="slurpy -c -u"                  # Update & List upgradeable
alias aurss="slurpy -c -s"                  # Search for a package
alias aursi="slurpy -c -i"                  # Package info
alias aurgo="slurpy -c -g"                  # Visit AUR page
alias aurdl="slurpy -c -d"                  # Download a package without installing
# }}}

# {{{ Completion
compctl -k "(add delete draft edit list import preview publish update)" nb
# }}}
# }}}

alias skype='xhost +local: && sudo -u skypeuser /usr/bin/skype'
# }}}

# {{{ ZSH settings
setopt emacs
setopt nohup
setopt autocd
setopt cdablevars
setopt ignoreeof
setopt nobgnice
#setopt nobanghist
setopt noclobber
setopt shwordsplit
setopt interactivecomments
setopt autopushd pushdminus pushdsilent pushdtohome
setopt histreduceblanks histignorespace inc_append_history

# Prompt requirements
#source ~/.zsh/git-prompt/zshrc.sh
#setopt extended_glob prompt_subst
autoload colors zsh/terminfo

# New style completion system
autoload -U compinit; compinit
#  * List of completers to use
zstyle ":completion:*" completer _complete _match #_approximate
#  * Allow approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
#  * Selection prompt as menu
zstyle ":completion:*" menu select=1
#  * Menu selection for PID completion
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:kill:*" force-list always
zstyle ":completion:*:processes" command "ps -au$USER"
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;32"
#  * Don't select parent dir on cd
zstyle ":completion:*:cd:*" ignore-parents parent pwd
#  * Complete with colors
zstyle ":completion:*" list-colors ""

#  * Speed up tab complete
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# }}}


# {{{ Functions
function web ()   { "${BROWSER}" "http://yubnub.org/parser/parse?command=${*}" }
function pmem ()  { ps -o rss,comm -p `pgrep "$1"` }
function dsync () { rsync -lprt --progress --stats --delete "$1/" "$2/" }

function ssnap () {
    [ "$2" ] && tmout="$2"  || tmout=5
    [ "$3" ] && format="$3" || format=png
    fname="${HOME}/$1-`date +%d%m%y-%H%M`"
    for ((i=${tmout}; i>=1; i--)) do; echo -n "${i}.. "; sleep 1; done
    import -window root -quality 100 "${fname}.${format}"
    convert -resize "15%" "${fname}.${format}" "${fname}.th.${format}"
    echo ": ${fname}.${format}"
}

function extract () {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tbz2 | *.tar.bz2) tar -xvjf  "$1"     ;;
            *.txz | *.tar.xz)   tar -xvJf  "$1"     ;;
            *.tgz | *.tar.gz)   tar -xvzf  "$1"     ;;
            *.tar | *.cbt)      tar -xvf   "$1"     ;;
            *.zip | *.cbz)      unzip      "$1"     ;;
            *.rar | *.cbr)      unrar x    "$1"     ;;
            *.arj)              unarj x    "$1"     ;;
            *.ace)              unace x    "$1"     ;;
            *.bz2)              bunzip2    "$1"     ;;
            *.xz)               unxz       "$1"     ;;
            *.gz)               gunzip     "$1"     ;;
            *.7z)               7z x       "$1"     ;;
            *.Z)                uncompress "$1"     ;;
            *.gpg)       gpg2 -d "$1" | tar -xvzf - ;;
            *) echo 'Error: failed to extract "$1"' ;;
        esac
    else
        echo 'Error: "$1" is not a valid file for extraction'
    fi
}

# {{{ Terminal and prompt

# Git autocomplete speed fix
__git_files () {
    _wanted files expl 'local files' _files
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# }}}
# }}}

function tmux_create_or_attach() {
	tmux has-session -t $1 && tmux attach-session -t $1 || tmux new -s $1
}


# Less Colors for Man Pages
# http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;36m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'   # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[01;32m' # begin underline
# export GOPATH=/home/cbancroft/work/aircoil/go
# source /usr/share/nvm/init-nvm.sh
# nvm use --silent stable

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ "$XDG_SESSION_DESKTOP" = "sway" ] ; then
    # https://github.com/swaywm/sway/issues/595
    export _JAVA_AWT_WM_NONREPARENTING=1
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
