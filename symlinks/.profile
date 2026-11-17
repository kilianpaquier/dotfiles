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

# shellcheck disable=SC1091
# source nix to expand PATH with home-manager installed tools
if [ -f "$HOME/.local/state/nix/profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.local/state/nix/profile/etc/profile.d/nix.sh"
elif [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# set LD_LIBRARY_PATH so it includes nix user level libraries
[ -d "$HOME/.local/state/nix/profile/lib" ] && export LD_LIBRARY_PATH="$HOME/.local/state/nix/profile/lib${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}"

# source nix defined environment variables
if [ -f "$HOME/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh"
elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
  # shellcheck disable=SC1090
  . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
fi

# set PATH so it includes mise shims and command wrappers if it exists
[ -d "$HOME/.local/share/mise/shims" ] && PATH="$HOME/.local/share/mise/shims:$PATH"
[ -d "$HOME/.local/share/mise/command-wrappers/bin" ] && PATH="$HOME/.local/share/mise/command-wrappers/bin:$PATH"

# set DOCKER_HOST so docker CLI targets the rootless daemon if it's installed
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/docker.service" ] && export DOCKER_HOST="unix://${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/docker.sock"

# set SSH_AUTH_SOCK so ssh tools target the home-manager ssh-agent if it's running
[ -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent" ] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent"

unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy

# set PATH so it includes krew if it exists
command -v kubectl-krew >/dev/null 2>&1 && PATH="${KREW_ROOT:-"$HOME/.krew"}/bin:$PATH"

# source mise env and aliases
export MISE_ENV=secrets
command -v mise >/dev/null 2>&1 && eval "$(mise env | grep -v 'PATH=')"

# set go cache variables
if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/.cache/go"
  export GOBIN="$GOPATH/bin"
  # set PATH so it includes go global installations
  PATH="$GOBIN:$PATH"

  export GOCACHE="$HOME/.cache/go-build"
  export GOLANGCI_LINT_CACHE="$HOME/.cache/golangci-lint"
fi

# set convenient variable ssh keys lifetime within ssh-agent (e.g. ssh-add -t "$SSH_AGENT_TIMEOUT")
export SSH_AGENT_TIMEOUT=3600
# use a private mask for gopass since it's the keyring (saves secrets)
export GOPASS_UMASK=077
# use '$$' to source the profile once per PID (and usually its sub-shells too, like '(...)' calls)
export PROFILE_SOURCED=$$
