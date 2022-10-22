#!/usr/bin/env fish

# The root of the checkout directory
set SRC_ROOT (cd (dirname (status -f))/.. && pwd -P)
export SRC_ROOT

source "$SRC_ROOT/scripts/lib/init.fish"

# Log the host platform for easy debugging
set host_platform $(util::host_platform)
log::info "Detected platform: $host_platform"

