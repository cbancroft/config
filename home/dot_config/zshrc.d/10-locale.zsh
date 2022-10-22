if locale -a | grep -q "en_US.utf8"; then
	export LANG=en_US.UTF-8
	export LC_CTYPE=en_US.UTF-8
	export LC_COLLATE=en_US.UTF-8
	export LC_MESSAGES=en_US.UTF-8
fi
