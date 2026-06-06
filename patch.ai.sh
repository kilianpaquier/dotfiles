#!/bin/sh

set -e

dir="$(realpath "$(dirname "$0")")"

mkdir -p "$HOME/.claude"
files=".claude/CLAUDE.md .claude/rules"
for file in $files; do ln -sfT "$dir/$file" "$HOME/$file"; done
unset file files

# Copilot can read .claude
mkdir -p "$HOME/.copilot"
# files=".copilot/copilot-instructions.md .copilot/instructions"
# for file in $files; do ln -sfT "$dir/$file" "$HOME/$file"; done
# unset file files

merge_json() {
  src="$1"
  dst="$2"
  if [ -f "$dst" ]; then
    tmp="$(mktemp)"
    jq -s '.[0] * .[1]' "$dst" "$src" > "$tmp" && mv "$tmp" "$dst"
  else
    cp "$src" "$dst"
  fi
}
merge_json "$dir/.claude/settings.json" "$HOME/.claude/settings.json"
merge_json "$dir/.copilot/settings.json" "$HOME/.copilot/settings.json"
