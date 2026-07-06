#!/bin/sh
# source'd by all shells

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  if test -r ~/.dircolors; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lart'
alias l='ls -CF'

if command -v kubectl >/dev/null 2>&1; then alias k=kubectl; fi
if command -v terraform >/dev/null 2>&1; then alias tf=terraform; fi
