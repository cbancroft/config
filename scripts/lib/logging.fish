#!/usr/bin/env fish

# Verbosity of script output and logging
set -q VERBOSE; or set VERBOSE 0

# return the current time in ISO 8601 UTC
function log::timestamp 
	set timestamp (date -u +"[%Y-%m-%dT%H:%M:%SZ]")
	echo "$timestamp"
end

# return the string rep of the current log level
function log::level::to_string 
	set -q LVL; or set LVL 0
	set level_str ""
	switch $LVL
		case 0
		  set level_str ""
		case 1
		  set level_str "I"
		case "*"
		  set level_str "D"
	end
	echo "$level_str"
end

# Log leveled printing, will only print if VERBOSE is greater than LVL
#
# Set $LVL to the threshold needed to print the message (defaults to 0)
# example: LVL=3 log::leveled "Printed if log level is 3 or above"

function log::level::log 
  set -q LVL; or set LVL 0
  if test $VERBOSE -ge $LVL
    for message in $argv
      echo "$(log::level::to_string)$(log::timestamp) $message"
		end
  end
end

# Logs the message at the INFO level
function log::echo 
  echo "$argv[1]"
  set --erase argv[1]
  for message in $argv
    echo "    $message"
	end
end

function log::always 
  LVL=0 log::level::log $argv
end

# Logs the message at the INFO level
function log::info 
  LVL=1 log::level::log $argv
end

# Logs the message at the DEBUG level
function log::debug 
  LVL=2 log::level::log $argv
end

function log::status 
  echo "+++ $(log::timestamp) $argv[1]"
  set --erase argv[1]
  for message in $argv
    echo "    $message"
	end
end

# Logs an error with timestamp prefixed
function log::error 
  set_color red; echo "!!! $(log::timestamp) $1" >&2
  set --erase argv[1]
  for message in $argv
    echo "    $message" >&2
	end

  set_color normal
end

#############
# The following code was adapted from the following Github Gist
# https://gist.github.com/ahendrix/7030300

set PROC $fish_pid

# Installs the function to be called when an ERR is caught.
#
# Note: this should be called very early in the shell script.
function log::enable_errexit 
  # trap ERR to provide an error handler whenever a command exits nonzero
  #  this is a more verbose version of set -o errexit
  trap 'log::error::exit' EXIT

  # setting errtrace allows our ERR trap handler to be propagated to functions,
  #  expansions and subshells
  # set -o errtrace

  # Define USER signal to trigger script exit with return code 30
  trap "exit 30" SIGUSR1
end

# ERR Trap handler to automatically catch any errors
function log::error::exit 
#  set err "$PIPESTATUS[@]"
#
#  # If the shell we are in doesn't have errexit set (common in subshells) then
#  # don't dump stacks.
#  #set +o | grep -qe "-o errexit" || return
#
#  set +o xtrace
#  local code="${1:-1}"
#  log::error_exit "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $err" "${1:-1}" 1
end

# Print out the stack trace
#
# Args:
#   $1 The number of stack frames to skip when printing.
function log::error::stacktrace 

  echo ""
#  local stack_skip=${1:-0}
#  stack_skip=$((stack_skip + 1))
#  if [[ ${#FUNCNAME[@]} -gt $stack_skip ]]; then
#    ansi --red "Call stack:" >&2
#    local i
#    for ((i=1 ; i <= ${#FUNCNAME[@]} - $stack_skip ; i++))
#    do
#      local frame_no=$((i - 1 + stack_skip))
#      ansi --red " $i: ${BASH_SOURCE[$frame_no]}:${BASH_LINENO[$frame_no-1]} ${FUNCNAME[$frame_no]}(...)" >&2
#    end
#  end

end

#############
# Log an error and exits
#
# Args:
#   $1 Error message
#   $2 The error code to return (defaults to 1)
#   $3 The number of stack frames to skip when printing. (defaults to 0)

function log::error_exit 
  set -q message "$argv[1]"; or set message ''
  set -q code "$argv[2]"; or set code -1
  set -q stack_skip "$argv[3]"; or set stack_skip 0
  set stack_skip (math $stack_skip + 1)

  # print the file and line number that called error_exit
  set source_file (status -f)
  set source_line (status -n)
  set_color red; echo "!!! Error in $source_file:$source_line" >&2

  echo (status stack-trace)
  # print the provided error message (if present)
  if test -n "$message"
    echo "  $message" >&2
  end

  # print the call stack if 
  if test $VERBOSE -ge 1
     log::error::stacktrace $stack_skip
  end

  set_color red; echo "Exiting with status $code" >&2
  
  set_color normal
  # Kill the original process if within a subshell
#  if test "$BASHPID" -ne "$PROC"
#    ansi --green "Note: exiting from within a subshell, return code will be 30" >&2
#    kill -SIGUSR1 $PROC
#  end

  exit (math $code + 0)
end
