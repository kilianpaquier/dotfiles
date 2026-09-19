#!/bin/sh

set -e

# shellcheck disable=SC1091
[ ! -f "$HOME/.profile" ] || . "$HOME/.profile"

nix-channel --update
home-manager switch
nix-collect-garbage --delete-older-than 30d
