#!/bin/sh

set -e

SCRIPT_DIR="$(dirname "$0")"

for file in "$SCRIPT_DIR"/scripts/sh/*.sh; do
    # shellcheck disable=SC1090
    . "$file"
done

[ -n "$INSTALL_DIR" ] || INSTALL_DIR="$HOME/.local" # default installation directory, may be overridden by -d or --dir

usage() {
    echo "$(basename "$0") -- Easy setup of a codespace or remote debian / ubuntu machine

Options:
    -d, --dir           Set the installation directory (default: $INSTALL_DIR), does not apply for tools installed with apt
    -h, --help          Show this help message
    -v, --verbose       Enable verbose mode (set -x) to log every step

        --bun           Install or upgrade bun
        --docker        Install or upgrade docker (rootless)
        --git           Setup default git configuration
        --go            Install or upgrade go, golangci-lint, hugo and goreleaser
        --k8s           Install or upgrade kubectl with k alias, k9s and helm
        --node          Install or upgrade node (install with apt)
        --pnpm          Install or upgrade pnpm
        --psql          Install or upgrade postgresql (install with apt)
        --shellcheck    Install or upgrade shellcheck
        --trivy         Install or upgrade trivy

Notes:
    All installation are done by default in $INSTALL_DIR. It may be overridden by -d or --dir."
}

# show usage if no arguments are provided
if [ "$#" -eq 0 ]; then
    usage && exit 2
fi

PARAMS=""
while [ "$#" -ne 0 ]; do
    case "$1" in
    -h | --help) usage && exit 0 ;; # early return in case help is asked
    -v | --verbose) set -x && shift ;;
    -d | --dir)
        [ -n "$2" ] || (usage && log_error "Missing argument for $1" && exit 1)
        INSTALL_DIR="$2" && shift 2 ;;

    --bun) BUN=0 && shift ;;
    --docker) DOCKER=0 && shift ;;
    --git) GIT=0 && shift ;;
    --go) GO=0 && shift ;;
    --k8s) K8S=0 && shift ;;
    --node) NODE=0 && shift ;;
    --pnpm) PNPM=0 && shift ;;
    --psql) PSQL=0 && shift ;;
    --shellcheck) SHELLCHECK=0 && shift ;;
    --trivy) TRIVY=0 && shift ;;
    -*) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    # --*=) usage && log_error "Unsupported flag $1" >&2 && exit 1 ;; # unsupported flags
    *) PARAMS="$PARAMS $1" && shift ;; # preserve positional arguments
    esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

log_info "Installing tools in $INSTALL_DIR"
check_install_dir

default_apt

[ "$BUN" = 0 ] && install_bun
[ "$DOCKER" = 0 ] && install_docker
[ "$GIT" = 0 ] && git_config
[ "$GO" = 0 ] && install_go && install_golangci_lint && install_hugo && install_goreleaser && install_gotools
[ "$K8S" = 0 ] && install_kubectl && install_k9s && install_helm
[ "$NODE" = 0 ] && install_node
[ "$PNPM" = 0 ] && install_pnpm
[ "$PSQL" = 0 ] && install_postgres
[ "$SHELLCHECK" = 0 ] && install_shellcheck
[ "$TRIVY" = 0 ] && install_trivy

auto_remove
