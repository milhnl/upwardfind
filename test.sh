set -eu

die() { printf '%s\n' "$*" >&2; exit 1; }

. ./upwardfind.sh

dir="$(mktemp -d)"
subdir="$dir/nested/and/another/level"

touch "$dir/stem.ext"
mkdir -p "$subdir"
touch "$subdir/stem.ext"
cd "$(mktemp -d)"

testfind() { #1:description 2:exit 3:stdout 4...:args
    for x in PWD OLDPWD; do
        eval "s$x=\"\$$x\""
    done
	sh="$(ps -p $$ -o comm=)"
	exit=0
	out="$(shift 3; upwardfind "$@")" || exit=$?
	[ "$exit" = "$2" ] || echo "$sh $1: Exit status $exit does not match expected"
	[ "$out" = "$3" ] || echo "$sh $1: expected: $3 and got $out"
    for x in PWD OLDPWD; do
        [ "$(eval "echo \"\$$x"\")" = "$(eval "echo \"\$s$x"\")" ] \
            || echo "$sh upwardfind overwrote $x"
    done

}

testfind "same directory" 0 "$subdir/stem.ext" -C "$subdir" stem.ext "$subdir"
testfind "way up" 0 "$dir/stem.ext" -C "$(dirname "$subdir")" stem.ext
testfind "glob same directory" 0 "$dir/stem.ext" -C "$(dirname "$subdir")" '*.ext'
testfind "file won't exist" 1 "" -C "$(dirname "$subdir")" \
	'thisfileshouldnotexistlet'\''shopeforthebest'

rm -r "$dir"
