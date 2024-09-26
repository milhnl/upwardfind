#!/usr/bin/env sh
#upwardfind - find file/dir matching glob in parent folders

upwardfind() { #1:glob 2?:path
	set -- "$(echo "$1" | sed 's/\([^A-Za-z0-9*.-]\)/\\\1/g')" "${2-$PWD}"
	while [ "$2" != / ]; do
		set -- "$1" "$2" \
			"$(eval "(set -- \"\${2%/}/\"$1; echo \"\$1\")" 2>/dev/null)"
		if [ -e "$3" ]; then
			echo "$3"
			return 0
		else
			set -- "$1" "$(dirname "$2")"
		fi
	done
	return 1
}

#upwardfind "$@"
