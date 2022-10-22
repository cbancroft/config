
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILESIZE=10000000
setopt histignorespace
setopt appendhistory
setopt incappendhistory
setopt sharehistory
setopt HIST_FIND_NO_DUPS
setopt notify
unsetopt beep
setopt nohup
setopt autocd
setopt cdablevars
setopt ignoreeof
setopt nobgnice
setopt noclobber
setopt shwordsplit
setopt interactivecomments
setopt autopushd pushdminus pushdsilent pushdtohome

bindkey -v

disable -r time

setopt extendedglob

