#!/bin/zsh
# shellcheck disable=SC1071

# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

[ ! -f "$HOME/.zprofile" ] || . "$HOME/.zprofile"

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update 'no'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard 'pc'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv' enable 'no'

# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*' enable 'no'

# Source additional local files if they exist.
z4h source "$HOME/.env.zsh"

# Extend environment (aliases and PATH).
# path=(~/bin $path)
[ ! -f "$HOME/.bash_aliases" ] || . "$HOME/.bash_aliases"

# Export environment variables.
export GPG_TTY=$TTY

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
