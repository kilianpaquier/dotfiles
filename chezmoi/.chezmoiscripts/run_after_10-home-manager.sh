#!/bin/sh

set -e

# shellcheck disable=SC1091
[ ! -f "$HOME/.profile" ] || . "$HOME/.profile"

nix-channel --update
home-manager switch --log-format bar
nix-collect-garbage --quiet --delete-older-than 30d
