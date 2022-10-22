
# Determines the host platform using native OS tools (no external dependencies)
function util::host_os
  set host_os ''
  switch "$(uname -s)"
    case Darwin
      set host_os darwin
    case Linux
      set host_os linux
    case MSYS_NT* or MINGW64_NT*
      set host_os win
    case '*'
      log::error_exit "Unsupported host OS: $(uname -s)" 33
      exit 1
end
  echo "$host_os"
end

function util::host_arch
  set host_arch ''
  switch "$(uname -m)"
    case 'x86_64*'
      set host_arch amd64
    case 'i?86_64*'
      set host_arch amd64
    case 'amd64*'
      set host_arch amd64
    case 'arm64*'
      set host_arch arm64
    case 'i?86*'
      set host_arch x86
    case '*'
      log::error_exit "Unsupported host arch: $(uname -m)" 33
end
  echo "$host_arch"
end

function util::host_platform
  echo "$(util::host_os)/$(util::host_arch)"
end

# Runs the given command and ignores any err signals
function util::run_no_err
  # traps are ignored in conditions, so catching and ignoring any errors
  if test ! ("$argv")
    : # dead code
	end
end

# Test if $1 is available
function util::is_available
	type "$1" &>/dev/null
end

