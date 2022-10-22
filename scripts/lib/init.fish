# unset CDPATH
echo "In init.sh :: (cd (dirname (status -f))/../.. && pwd -P)"
set SCRIPT_DIR (dirname (status -f))
set SRC_ROOT $(dirname (status -f))/../..
source "$SRC_ROOT/scripts/lib/logging.fish"

log::enable_errexit

source "$SRC_ROOT/scripts/lib/utils.fish"
