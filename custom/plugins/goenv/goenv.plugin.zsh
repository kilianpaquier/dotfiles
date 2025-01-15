export GOPATH="$HOME/.cache/go"
export PATH="$PATH:$GOPATH/bin"

export GOLANGCI_LINT_CACHE="$HOME/.cache/golangci-lint"

if (( ! $+commands[go] )); then return; fi
read GOCACHE < <(go env GOCACHE)
export GOCACHE

read GOBIN < <(go env GOBIN)
export GOBIN
export PATH="$PATH:$GOBIN"