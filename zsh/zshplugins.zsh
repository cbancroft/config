#!/usr/bin/env zsh

# Clone zgenom if you haven't already
if [[ -z "$ZGENOM_PARENT_DIR" ]]; then
    ZGENOM_PARENT_DIR=$HOME
    ZGENOM_SOURCE_FILE=$ZGENOM_PARENT_DIR/.zqs-zgenom/zgenom.zsh

    # Set ZGENOM_SOURCE_FILE to the old directory if it already exists
    if [[ -f "$ZGENOM_PARENT_DIR/zgenom/zgenom.zsh" ]]; then
        ZGENOM_SOURCE_FILE=$ZGENOM_PARENT_DIR/zgenom/zgenom.zsh
    fi
fi

# zgenom stores the clones plugins & themes in $ZGEN_DIR when it
# is set. Otherwise it stuffs everything in the source tree, which
# is unclean.
ZGEN_DIR=${ZGEN_DIR:-$HOME/.zgenom}

if [[ ! -f "$ZGENOM_SOURCE_FILE" ]]; then
    if [[ ! -d "$ZGENOM_PARENT_DIR" ]]; then
        mkdir -p "$ZGENOM_PARENT_DIR"
    fi
    pushd $ZGENOM_PARENT_DIR
    git clone https://github.com/jandamm/zgenom.git .zqs-zgenom
    popd
fi

if [[ ! -f "$ZGENOM_SOURCE_FILE" ]]; then
    echo "Can't find zgenom.zsh"
else
    # echo "Loading zgenom"
    source "$ZGENOM_SOURCE_FILE"
fi

unset ZGENOM_PARENT_DIR ZGENOM_SOURCE_FILE

load-starter-plugin-list() {
    echo "Creating a zgenom save"
    ZGEN_LOADED=()
    ZGEN_COMPLETIONS=()

    if [[ ! -f ~/.zsh-quickstart-no-omz ]]; then
        zgenom oh-my-zsh
    fi

    # If you want to customize your plugin list, create a file named
    # .zsh-quickstart-local-plugins-example in your home directory. That
    # file will be sourced during startup *instead* of running this
    # load-starter-plugin-list function, so make sure to include everything
    # from this function that you want to keep.
    #
    # To make customizing easier, there's a .zsh-quickstart-local-plugins-example
    # file at the top level of the zsh-quickstart-kit repository that you can
    # copy as a starting point. This keeps you from having to maintain a fork of
    # the quickstart kit.

    # If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
    # they break, so get the order right.
    zgenom load zsh-users/zsh-syntax-highlighting
    zgenom load zsh-users/zsh-history-substring-search

    # Set keystrokes for substring searching
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down

    # Automatically run zgenom update and zgenom selfupdate every 7 days.
    zgenom load unixorn/autoupdate-zgenom

    # Colorize the things if you have grc installed. Well, some of the
    # things, anyway.
    zgenom load unixorn/warhol.plugin.zsh

    # Warn you when you run a command that you've set an alias for without
    # using the alias.
    zgenom load djui/alias-tips

    # Add my collection of git helper scripts.
    zgenom load unixorn/git-extra-commands

    # Supercharge your history search with fzf
    zgenom load unixorn/fzf-zsh-plugin

    # A collection of scripts that might be useful to sysadmins.
    zgenom load skx/sysadmin-util

    # Adds aliases to open your current repo & branch on github.
    zgenom load peterhurford/git-it-on.zsh

    # Load some oh-my-zsh plugins
    zgenom oh-my-zsh plugins/pip
    zgenom oh-my-zsh plugins/sudo
    zgenom oh-my-zsh plugins/aws
    zgenom oh-my-zsh plugins/chruby
    zgenom oh-my-zsh plugins/colored-man-pages
    zgenom oh-my-zsh plugins/git
    zgenom oh-my-zsh plugins/github
    zgenom oh-my-zsh plugins/python
    zgenom oh-my-zsh plugins/rsync
    zgenom oh-my-zsh plugins/screen
    zgenom oh-my-zsh plugins/vagrant

    zgenom load chrissicool/zsh-256color

    # Load more completion files for zsh from the zsh-lovers github repo.
    zgenom load zsh-users/zsh-completions src

    # Docker completion
    zgenom load srijanshetty/docker-zsh

    # Load me last
    GENCOMPL_FPATH=$HOME/.zsh/complete

    # Very cool plugin that generates zsh completion functions for commands
    # if they have getopt-style help text. It doesn't generate them on the fly,
    # you'll have to explicitly generate a completion, but it's still quite cool.
    zgenom load RobSis/zsh-completion-generator

    # Add Fish-like autosuggestions to your ZSH.
    zgenom load zsh-users/zsh-autosuggestions

    # k is a zsh script / plugin to make directory listings more readable,
    # adding a bit of color and some git status information on files and
    # directories.
    zgenom load supercrabtree/k

    # p10k is faster and what I'm using now, so it is the new default
    zgenom load romkatv/powerlevel10k powerlevel10k

    # Save it all to init script.
    zgenom save
}

setup-zgen-repos() {
    ZQS_override_plugin_list=''
    # If they have both, the new name takes precedence
    if [[ -r $HOME/.zsh-quickstart-local-plugins ]]; then
        ZQS_override_plugin_list="$HOME/.zsh-quickstart-local-plugins"
    fi

    if [[ -r "$ZQS_override_plugin_list" ]]; then
        echo "Loading local plugin list from $ZQS_override_plugin_list"
        source "$ZQS_override_plugin_list"
        unset ZQS_override_plugin_list
    else
        load-starter-plugin-list
    fi
}

# This comes from https://stackoverflow.com/questions/17878684/best-way-to-get-file-modified-time-in-seconds
# This works on both Linux with GNU fileutils and macOS with BSD stat.

# Naturally BSD/macOS and Linux can't share the same options to stat.
if [[ $(uname | grep -ci -e Darwin -e BSD) = 1 ]]; then

    # macOS version.
    get_file_modification_time() {
        modified_time=$(stat -f %m "$1" 2>/dev/null) || modified_time=0
        echo "${modified_time}"
    }

elif [[ $(uname | grep -ci Linux) = 1 ]]; then

    # Linux version.
    get_file_modification_time() {
        modified_time=$(stat -c %Y "$1" 2>/dev/null) || modified_time=0
        echo "${modified_time}"
    }
fi

# check if there's an init.zsh file for zgen and generate one if not.
if ! zgen saved; then
    setup-zgen-repos
fi

# Our installation instructions get the user to make a symlink
# from ~/.zgen-setup to wherever they checked out the zsh-quickstart-kit
# repository.
#
# Unfortunately, stat will return the modification time of the
# symlink instead of the target file, so construct a full path to hand off
# to stat so it returns the modification time of the actual .zgen-setup file.
if [[ -f ~/.zgen-setup ]]; then
    REAL_ZGEN_SETUP=~/.zgen-setup
fi
if [[ -L ~/.zgen-setup ]]; then
    REAL_ZGEN_SETUP="$(readlink ~/.zgen-setup)"
fi

# If you don't want my standard starter set of plugins, create a file named
# .zsh-quickstart-local-plugins and add your zgenom load commands there. Don't forget to
# run `zgenom save` at the end of your .zsh-quickstart-local-plugins file.
#
# Warning: .zgen-local-plugins REPLACES the starter list setup, it doesn't
# add to it.
#
# Use readlink in case the user is symlinking from another repo checkout, so
# they can use a personal dotfiles repository cleanly.
if [[ -f ~/.zgen-local-plugins ]]; then
    REAL_ZGEN_SETUP=~/.zgen-local-plugins
fi
if [[ -L ~/.zgen-local-plugins ]]; then
    REAL_ZGEN_SETUP="${HOME}/$(readlink ~/.zgen-local-plugins)"
fi
# Old file still works for backward compatibility, but we want the new file
# to take precedence when both exist.
if [[ -f ~/.zsh-quickstart-local-plugins ]]; then
    REAL_ZGEN_SETUP=~/.zsh-quickstart-local-plugins
fi
if [[ -L ~/.zsh-quickstart-local-plugins ]]; then
    REAL_ZGEN_SETUP="${HOME}/$(readlink ~/.zsh-quickstart-local-plugins)"
fi

# echo "REAL_ZGEN_ZETUP: $REAL_ZGEN_SETUP"

# If .zgen-setup is newer than init.zsh, regenerate init.zsh
if [ $(get_file_modification_time ${REAL_ZGEN_SETUP}) -gt $(get_file_modification_time ~/.zgenom/init.zsh) ]; then
    echo "$(basename ${REAL_ZGEN_SETUP}) ($REAL_ZGEN_SETUP) updated; creating a new init.zsh from plugin list in ${REAL_ZGEN_SETUP}"
    setup-zgen-repos
fi
unset REAL_ZGEN_SETUP
