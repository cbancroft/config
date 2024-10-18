if [ -f "$HOME/.pythonrc" ]; then
	export PYTHONSTARTUP=$HOME/.pythonrc
fi

export EDITOR=nvim
export PAGER=bat

# Path to my second brain
export SECOND_BRAIN=$HOME/brain

export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:$PATH"
## eval "$(pyenv init --path)"
eval "$(fzf --zsh)"
