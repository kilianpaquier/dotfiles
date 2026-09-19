#!/bin/sh

set -e

# shellcheck disable=SC1091
[ ! -f "$HOME/.profile" ] || . "$HOME/.profile"

mise install -y
mise upgrade -y
mise prune -y
mise reshim --force -y
