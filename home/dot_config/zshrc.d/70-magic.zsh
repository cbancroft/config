# Magic
set_abbreviations() {
	typeset -Ag abbreviations
	abbreviations=(
		"Le"	"| less"
		"Eg"	"| egrep"
		"Ta"	"| tail"
		"Tl"	"tail -F"
		"So"	"| sort"
		"Cm"	"git commit -p __CURSOR__"
		"Cma"	"git commit -p --amend __CURSOR__"
		"Pu"	"${push_command} __CURSOR__"
		)
}

get_git_push_cmd() {
	if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
		if ! git_branch=$(git rev-parse --abrev-ref HEAD 2>/dev/null); then
			git_branch=$(git_main_branch || echo "main")
		fi
		push_command="git push origin $git_branch"
	else
		push_command='Pu'
	fi
}

magic-abbrev-expand() {
	get_git_push_cmd
	set_abbreviations
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
	command=${abbreviations[$MATCH]}
	LBUFFER+=${command:-$MATCH}

	if [[ "${command}" =~ "__CURSOR__" ]]; then
		RBUFFER=${LBUFFER[(ws:__CURSOR__:)2]}
		LBUFFER=${LBUFFER[(ws:__CURSOR__:)1]}
	else
		zle self-insert
	fi
}

no-magic-abbrev-expand() {
		LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand
bindkey -M isearch " " self-insert

