#!/bin/sh

set -e

dir="$(realpath "$(dirname "$0")")"

files=".bash_aliases .bash_logout .bashrc .profile .zshrc"
for file in $files; do ln -sf "$dir/$file" "$HOME/$file"; done
unset file files
