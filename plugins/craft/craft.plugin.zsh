# Wrap useful binaries with local build if present
craft() {
  local bin="$HOME/workspaces/github.com/kilianpaquier/craft/craft"
  if [ -f "$bin" ]; then "$bin" "$@"; else command craft "$@"; fi
}

eval "$(craft completion zsh)"