#!/bin/sh

set -e

dir="$(realpath "$(dirname "$0")")"

files=".bash_aliases .bash_logout .bashrc .profile .zshrc .config/mise/config.toml"
for file in $files; do
  link_dir=$(dirname "$file")
  [ "$link_dir" = "." ] || mkdir -p "$HOME/$link_dir"
  ln -sf "$dir/$file" "$HOME/$file"
done
unset file files
