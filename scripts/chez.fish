#!/usr/bin/env fish 
set SRC_ROOT (cd (dirname (status -f))/.. && pwd -P)
set SCRIPTS_ROOT (cd (dirname (status -f)) && pwd -P)
source "$SCRIPTS_ROOT/lib/init.fish"

set -x PATH "$HOME/bin:$SRC_ROOT/bin:/opt/homebrew/bin:$PATH"

set -q SECRETS; or set SECRETS ''

if test -z "$SECRETS"
		log::info "NOTE: Using default config"
		set -qx SRC_DIR; or set -gx SRC_DIR $SRC_ROOT
		set -qx CFG_FILE; or set -gx CFG_FILE $HOME/.config/chezmoi/clbancro-default/chezmoi.yaml
else
		log::info "NOTE: Using secrets config"
		set -qx SRC_DIR; or set -gx SRC_DIR $SRC_ROOT; and set -x SRC_DIR $SRC_DIR/secrets
		set -qx CFG_FILE; or set -gx CFG_FILE $HOME/.config/chezmoi/clbancro-secrets/chezmoi.yaml
end

export CFG_FILE
export SRC_DIR
source $SCRIPTS_ROOT/lib/run_chezmoi.fish $argv
