#!/bin/sh

set -e

dir="$(realpath "$(dirname "$0")")"

mkdir -p "$HOME/.claude"
for file in "$dir/.claude/"*; do ln -sfT "$file" "$HOME/.claude/$(basename "$file")"; done
unset file

mkdir -p "$HOME/.copilot"
for file in "$dir/.copilot/"*; do ln -sfT "$file" "$HOME/.copilot/$(basename "$file")"; done
unset file
