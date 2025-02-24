#!/bin/zsh
# shellcheck disable=SC1071

read -r me < <(readlink -f "$HOME/.zshrc")
read -r dir < <(dirname "$me")

source "$dir/.profile"
source "$dir/z4h/.zshrc"
