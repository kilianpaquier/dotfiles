<!-- This file is safe to edit. Once it exists it will not be overwritten. -->

# dotfiles <!-- omit in toc -->

<p align="center">
  <img alt="GitHub Issues" src="https://img.shields.io/github/issues-raw/kilianpaquier/dotfiles?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/kilianpaquier/dotfiles?style=for-the-badge">
</p>

---

- [Windows](#windows)
- [Debian](#debian)
  - [CLI](#cli)

## Windows

In a powershell terminal:

```ps1
(New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/kilianpaquier/dotfiles/main/install.ps1") | wt powershell -command -
```

## Debian

In any terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/kilianpaquier/dotfiles/main/install.sh | bash
```

Available options:
- `HTTP_CLONE`: When defined (no matter its value), all clones will be done with HTTP(s), otherwise it'll be if the following glob doesn't return any file `$HOME/.ssh/id_*`.

```sh
HTTP_CLONE=1 curl -fsSL https://raw.githubusercontent.com/kilianpaquier/dotfiles/main/install.sh | bash
```

### CLI

```
cli.sh -- Easy setup of a codespace or remote debian / ubuntu machine

Options:
        --gh            Install or upgrade github CLI
        --go            Install or upgrade go, golangci-lint, hugo and goreleaser
        --psql          Install or upgrade postgresql
    -b, --bun           Install or upgrade bun
    -d, --docker        Install or upgrade docker (rootless)
    -g, --git           Setup default git configuration
    -h, --help          Show this help message
    -k, --k8s           Install or upgrade kubectl with k alias, k9s and helm
    -n, --nodejs        Install or upgrade nodejs and pnpm
    -s, --shellcheck    Install or upgrade shellcheck
    -t, --trivy         Install or upgrade trivy
    -v, --verbose       Enable verbose mode to log every step

Notes:
    All installation are done in /home/debian/.local.
```
