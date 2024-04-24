if [ "$TERM" = "xterm" ]; then
	export TERM=xterm-256color
fi

if [ -f "$HOME/.pythonrc" ]; then
	export PYTHONSTARTUP=$HOME/.pythonrc
fi

export EDITOR=nvim
export PAGER=bat

export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
## eval "$(pyenv init --path)"
eval "$(fzf --zsh)"
