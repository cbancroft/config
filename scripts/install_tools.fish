#!/usr/bin/env fish

# source the init script
set SRC_ROOT $(cd "$(dirname (status -f))"/.. && pwd -P)
set SCRIPTS_ROOT $(cd "$(dirname (status -f))"/. && pwd -P)
source "$SCRIPTS_ROOT/lib/init.fish"

# Make sure common user bin directories are on the path
set -x PATH "$HOME/bin:$SRC_ROOT/bin:/opt/homebrew/bin:$PATH"

log::info "HOST_OS=$(util::host_os)"
if test "$(util::host_os)" = "darwin*"
    # install homebrew
    if util::is_available brew; then
        set_color yellow;echo "Homebrew is installed. Skipping";set_color normal
    else
        set_color green;echo "Homebrew not installed. Installing...";set_color normal
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew analytics off
    end

    # Install Chezmoi
    if util::is_available chezmoi
        set_color yellow; echo "Chezmoi is installed. Skipping"; set_color normal
    else
        set_color green; echo "Chezmoi not installed. Installing..."; set_color normal
        brew install chezmoi
end

    # Install LastPass-CLI
    if util::is_available chezmoi
	set_color yellow; echo "LastPass-CLI is installed. Skipping"; set_color normal
    else
        set_color green; echo "LastPass-CLI not installed. Installing..."; set_color normal
        brew install lastpass-cli
    end
elif test "$(util::host_os)" = "linux*"
    set_color yellow; echo "Warning Linux support is untested."; set_color normal
     if util::is_available chezmoi
        set_color yellow; echo "Chezmoi is installed. Skipping"; set_color normal
    else
        set_color green; echo "Chezmoi not installed. Installing..."; set_color 

        # Set the bin directory as Chezmoi uses this as the install directory
        set -x BINDIR "$HOME/bin"
        sh -c "$(wget -qO- https://chezmoi.io/get)" || sh -c "$(curl -fsLS https://chezmoi.io/get)"
end
end

