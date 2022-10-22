#!/usr/bin/env fish

# source the init script
set SCRIPTS_ROOT (cd (dirname (status -f)) && pwd -P)

source "$SCRIPTS_ROOT/lib/init.fish"

set CMD "$argv[1]"
if test -z "$CMD"
  log::error_exit "No log command specified"
end

set --erase argv[1]
if [ "$CMD" = "status" ]
  echo ""
  log::status "$argv"
else if  "$CMD" = "info" 
  LVL=0 log::level::log "$argv"
else
  LVL=1 log::debug "$argv"
end
