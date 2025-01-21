#!/bin/sh

dir="$(realpath "$(dirname "$0")")"

files=".bash_aliases .bash_logout .bashrc .profile .zshrc"
for _f in $files; do ln -sf "$dir/$_f" "$HOME/$_f"; done
unset _f
