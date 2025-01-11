alias k='kubectl'

if which craft &>/dev/null; then
  craft() {
    local bin="$HOME/workspaces/github.com/kilianpaquier/craft/craft"
    if [ -f "$bin" ]; then "$bin" "$@"; else command craft "$@"; fi
  }
  eval "$(craft completion zsh)"
fi

if which gitlab-storage-cleaner &>/dev/null; then
  gitlab-storage-cleaner() {
    local bin="$HOME/workspaces/github.com/kilianpaquier/gitlab-storage-cleaner/gitlab-storage-cleaner"
    if [ -f "$bin" ]; then "$bin" "$@"; else command gitlab-storage-cleaner "$@"; fi
  }
  eval "$(gitlab-storage-cleaner completion zsh)"
fi

if which go-builder-generator &>/dev/null; then
  go-builder-generator() {
    local bin="$HOME/workspaces/github.com/kilianpaquier/go-builder-generator/go-builder-generator"
    if [ -f "$bin" ]; then "$bin" "$@"; else command go-builder-generator "$@"; fi
  }
  eval "$(go-builder-generator completion zsh)"
fi
