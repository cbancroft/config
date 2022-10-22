#!/usr/bin/env fish
# source the init script
set SRC_ROOT (cd (dirname (status -f))/../.. && pwd -P)
set SCRIPTS_ROOT (cd (dirname (status -f))/.. && pwd -P)
source "$SCRIPTS_ROOT/lib/init.fish"

# Linux on Go likes to install into the local directory
set -x PATH "$HOME/bin:$SRC_ROOT/bin:$PATH"

set -q REINIT; or set REINIT false
set -q DRYRUN; or set DRYRUN false
set -q DATA; or set DATA $DATA

set -q SRC_DIR ; or set SRC_DIR $SRC_DIR
set -q CFG_DIR ; or set CFG_DIR $CFG_FILE
set -q DST_DIR ; or set DST_DIR $DST_DIR

set CMD $argv[1]
set --erase argv[1]

if test -z "$CMD"
  log::error_exit "No command specified, cannot execute Chezmoi"
end

# TODO: add support to pass in other arguments
set EXTRA_ARGS ''

# build the list of arguments to pass to Chezmoi
set args $CMD

if test "$CMD" = "init"
  echo "Init with REINIT=$REINIT"
  if test "$REINIT" = "true"
    set -a args "--data=false"
  else if test -n "$DATA"
    set -a args "--data=$DATA"
  end
  echo "Args: $args"
end

# Default to this source directory if another directory is not provided
if test -n "$SRC_DIR"
  set -a args "--source" "$SRC_DIR"
else
  set -a args "--source" "$SRC_ROOT"
end

# Chezmoi will default to using "~/.config/chezmoi/chezmoi.[yaml|toml|json]"
if test -n "$CFG_DIR"
  set -a args "--config" "$CFG_DIR"
  if test "$CMD" = "init"
    # Init requires the templated config-path to also be defined
    set -a args "--config-path" "$CFG_DIR"
end
end

# Chezmoi will default to $HOME
if test -n "$DST_DIR"
  set -a args "--destination" "$DST_DIR"
end

# enable debug and verbose logs if VERBOSE is set to a non-zero value
if test $VERBOSE -ge 1
  set -a args "--debug"
  if test $VERBOSE -ge 2
    set -a args "--verbose"
end
end

set args $args[1..-1] $argv

if test "$DRYRUN" = "true"
  set arg_str "$args[1..-1]"
  set_color green;
  set message $(echo chezmoi $arg_str)
  set_color normal
  log::status "DRYRUN" "$message"
else
  chezmoi $args[1..-1]
end

