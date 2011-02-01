
# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


## Important environment variables
export EDITOR="vim"
export PACMAN="pacman-color"
export DETERNET="users.isi.deterlab.net"
export DETERLAB="deter.d.bbn.com"

alias deternet="ssh -X cbancrof@${DETERNET}"
alias deterlab="ssh cbancrof@${DETERLAB}"

