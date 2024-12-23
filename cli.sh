#!/bin/sh

set -e

SCRIPT_DIR="$(dirname "$0")"

for file in "$SCRIPT_DIR"/scripts/sh/*.sh; do
    # shellcheck disable=SC1090
    . "$file"
done

[ -n "$INSTALL_DIR" ] || INSTALL_DIR="$HOME/.local" # default installation directory, may be overridden by -d or --dir

tools="bun docker go golangci-lint goreleaser helm hugo jfrog k9s kubectl node pnpm psql shellcheck trivy"

usage() {
    cat<<USAGE
$(basename "$0") -- Easy setup of a codespace or remote debian / ubuntu machine

Options:
    -d, --dir, --dir=       Set the installation directory (default: $INSTALL_DIR), does not apply for tools installed with apt
    -h, --help              Show this help message
    -v, --verbose           Enable verbose mode (set -x) to log every step

Configs:
        --git               Setup git configuration

Tools:
        $(echo "$tools" | sed 's/^/--/g' | sed 's/ /, --/g')

Notes:
    All installation are done by default in $INSTALL_DIR. It may be overridden by -d or --dir.
USAGE
}

# show usage if no arguments are provided
if [ "$#" -eq 0 ]; then
    usage && exit 2
fi

commands=""
while [ "$#" -ne 0 ]; do
    for tool in $tools; do
        if [ "$1" = "--$tool" ] || [ "$1" = "$tool" ]; then
            shift
            commands="$commands $(echo "install_$tool" | sed 's/-/_/g')"
            continue 2
        fi
    done

    case "$1" in
    -h | --help) usage && exit 0 ;; # early return in case help is asked
    -v | --verbose) set -x && shift ;;
    -d | --dir)
        [ -n "$2" ] || (usage && log_error "Missing argument for $1" && exit 1)
        INSTALL_DIR="$2" && shift 2 ;;
    --dir=*)
        INSTALL_DIR="${1#*=}" && shift ;;

    git | --git) commands="$commands git_config" && shift ;;
    *) usage && log_error "Unsupported flag '$1'" >&2 && exit 1 ;; # unsupported flags
    # --*=) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    # *) PARAMS="$PARAMS $1" && shift ;; # preserve positional arguments
    esac
done

log_info "Installing tools in $INSTALL_DIR"
check_install_dir

default_apt

for command in $commands; do $command; done

auto_remove
