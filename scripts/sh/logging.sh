#!/bin/sh

log_success() {
    fg="\033[0;32m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_info() {
    fg="\033[0;34m"
    reset="\033[0m"
    echo "${fg}$1${reset}"
}

log_warn() {
    fg="\033[0;33m"
    reset="\033[0m"
    echo "${fg}$1${reset}" >&2
}

log_error() {
    fg="\033[0;31m"
    reset="\033[0m"
    echo "${fg}$1${reset}" >&2
}
