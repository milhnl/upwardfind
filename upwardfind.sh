#!/usr/bin/env sh
#upwardfind - find file/dir matching glob in parent folders

upwardfind() (
	case "$1" in
	-C)
		cd "$2"
		shift 2
		;;
	-C*)
		cd "${1#-C}"
		shift
		;;
	--)
		shift
		;;
	esac
	set -- "$(
		for x; do
			printf %s\\n "$x" |
				sed "s/'/'\\\\''/g;s/\\(\\*\\)/'\\1'/;1s/^/'/;\$s/\$/' \\\\/"
		done
		echo " "
	)"
	while true; do
		(
			eval "set -- $1" 2>/dev/null
			for x; do
				if [ -e "$x" ]; then
					printf %s/%s "$PWD" "$x"
					return 0
				fi
			done
			return 1
		) && return 0
		[ "$PWD" != / ] || return 1
		cd ..
	done
	return 1
)

#upwardfind "$@"
