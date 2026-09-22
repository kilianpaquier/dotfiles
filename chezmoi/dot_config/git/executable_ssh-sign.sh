#!/bin/sh
# A simple script to autoload ssh keys in case they are not regirested
# and sign commits
#
# This script exists because while 'git pull' or 'git push' uses ssh under the hood to connect
# and update remote repositories, 'git commit' doesn't uses ssh but only 'ssh-keygen' to sign.
# This means that an ssh key not pre-registered under the ssh-agent will be prompted everytime (and it's quite annoying)

set -e

# extract key path from -f (comes from git config user.signingKey) without modifying $@
prev=
for arg in "$@"; do
  if [ "$prev" = "-f" ]; then
    SSH_SIGNING_KEY="$arg"
    break
  fi
  prev="$arg"
done

if [ -z "$SSH_SIGNING_KEY" ]; then
  exec ssh-keygen "$@" # early exit to just sign and not register any ssh key since none is known
fi
if [ ! -f "$SSH_SIGNING_KEY.pub" ]; then
  exec ssh-keygen "$@" # the key is already registered in advance (not lazy or manually) and command has a "-f /tmp/..." key path
fi

# check with public key material whether it's already registered under the ssh-agent
if ! ssh-add -L 2>/dev/null | grep -q "$(cut -d' ' -f2 "$SSH_SIGNING_KEY.pub")"; then
  ssh-add -t "${SSH_AGENT_TIMEOUT:-3600}" "$SSH_SIGNING_KEY" 2>/dev/null || true
fi

exec ssh-keygen "$@"
