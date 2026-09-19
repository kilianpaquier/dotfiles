#!/bin/sh

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# sourced once per shell (or child process)
[ "$PROFILE_SOURCED" != "$$" ] || return 0

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.

# Set the "umask" (see "man umask"):
# umask 002 # relaxed   -rwxrwxr-x
# umask 022 # cautious  -rwxr-xr-x
# umask 027 # uptight   -rwxr-x---
# umask 077 # paranoid  -rwx------
# umask 066 # bofh-like -rw-------
umask 022

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# set PATH so it includes bun global dependencies
[ -d "$HOME/.bun/bin" ] && PATH="$HOME/.bun/bin:$PATH"

# set PATH so it includes mise shims if it exists
[ -d "$HOME/.local/share/mise/shims" ] && PATH="$HOME/.local/share/mise/shims:$PATH"

# set PATH so it includes krew if it exists
[ -d "$HOME/.krew/bin" ] && PATH="$HOME/.krew/bin:$PATH"

# shellcheck disable=SC1091
# source nix
[ ! -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] || . "$HOME/.nix-profile/etc/profile.d/nix.sh"

unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy

# source mise env and aliases
command -v mise >/dev/null 2>&1 && eval "$(mise env | grep -v 'PATH=')"

# set go cache variables
if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/.cache/go"
  export GOBIN="$GOPATH/bin"
  # set PATH so it includes go global installations
  PATH="$GOBIN:$PATH"

  # shellcheck disable=SC2034
  export GOCACHE="$HOME/.cache/go-build"
  # shellcheck disable=SC2034
  export GOLANGCI_LINT_CACHE="$HOME/.cache/golangci-lint"
fi

export PROFILE_SOURCED=$$
