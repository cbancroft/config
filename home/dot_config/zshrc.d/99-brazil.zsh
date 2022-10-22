# Inspired by Kannadotfiles package

## Amazon Brazil aliases

alias bb='brazil-build'
alias bbb='brazil-recursive-cmd brazil-build'
alias bbs='brazil-build server'
alias bbc='brazil-build clean'
alias bbr='brazil-build release'
alias bp='brazil-path'
alias bre='brazil-runtime-exec'
alias bsync='brazil ws sync --md'
alias bshow='brazil ws show'
alias br='brazil-recursive-command'

# List targets for current package
alias bbt='brazil-build -p'
# List all targets for current project
alias bbta='brazil-build -p -verbose'

alias bwsclean='brazil workspace --clean'

# Brazil Recursive
brc() {
  CMD=`printf 'echo "Executing [%s] in $name" && %s && echo ""' "$1" "$1"`
  echo "Will run $CMD recursively..."
  brazil-recursive-cmd "$CMD"
}

brca() {
  CMD=`printf 'echo "Executing [%s] in $name" && %s && echo ""' "$1" "$1"`
  echo "Will run $CMD recursively..."
  brazil-recursive-cmd -all "$CMD"
}

# Brazil ThirdPartyTool
alias third-party-promote='~/.toolbox/bin/brazil-third-party-tool promote'
alias third-party='~/.toolbox/bin/brazil-third-party-tool'
