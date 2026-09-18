#!/bin/sh

# the pager runs the check itself, this covers an empty diff and --no-pager (no pager started)
pgrep -P "$PPID" -f pager.sh >/dev/null || "$(dirname "$0")/ansible.sh" --check --diff
