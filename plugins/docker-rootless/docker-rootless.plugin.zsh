# Docker rootless socket
[ -f "$HOME/.docker/config.json" ] && [ "$(jq -r ".currentContext" <"$HOME/.docker/config.json")" = "rootless" ] && export DOCKER_HOST="unix:///run/user/1000/docker.sock"
