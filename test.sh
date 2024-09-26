set -eu

die() { printf '%s\n' "$*" >&2; exit 1; }

. ./upwardfind.sh

dir="$(mktemp -d)"
subdir="$dir/nested/and/another/level"

touch "$dir/stem.ext"
mkdir -p "$subdir"
touch "$subdir/stem.ext"

testfind() { #1:description 2:glob 3:path 4:exit 5:stdout
	sh="$(ps -p $$ -o comm=)"
	out="$(upwardfind "$2" "$3")" && exit=0 || exit=$?
	[ "$exit" = "$4" ] || die "$sh $1: Exit status $exit does not match expected"
}

testfind "same directory" stem.ext "$subdir" 0 "$subdir/stem.ext"
testfind "way up" stem.ext "$(dirname "$subdir")" 0 "$dir/stem.ext"
testfind "glob same directory" '*.ext' "$(dirname "$subdir")" 0 "$dir/stem.ext"
testfind "file won't exist" 'thisfileshouldnotexistlet'\''shopeforthebest' \
	"$(dirname "$subdir")" 1 "$dir/stem.ext"

rm -r "$dir"
