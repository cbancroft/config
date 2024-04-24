zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:match:*' original only
zstyle -e ':completion:*:approximate:*' max-error 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $(whoami) -o pid,user,comm -w -w'
zstyle ':completion:*' rehash true
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
