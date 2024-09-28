# upwardfind

A small shell library that, given a path and a glob, finds the file or
directory that matches the glob in the nearest parent directory. Useful for
finding a project configuration file when creating a tool or something like
that. This is probably very niche, but I wanted to write a test script for my
own implementation, which you can find and try here.

## Installation

Copy-paste the `upwardfind.sh` script into your own code, or include it with
git submodule. This last method has two advantages: updates, and you can verify
that it works with `test.sh`.

## Usage

```sh
upwardfind [-C <directory>] <glob...>
```

If no directory is given, the current working directory is assumed. The globs
are evaluated by the shell itself, but must of course be quoted.

## Examples

```sh
#Find dotnet solution file for project
upwardfind '*.sln'

#Find documentation for file
upwardfind -C "$(dirname "$file")" README.md README
```

## Features

- Does not clobber the shell execution environment (`PWD`, variables, etc).
- Uses `cd` to find parent directory.
- Supports multiple globs.
- POSIX-compatible, so can be run in all shells. This is in some ways also a
  caveat, as it uses the shell's own machinery to evaluate the globs.
- Copy-paste-friendly license.
