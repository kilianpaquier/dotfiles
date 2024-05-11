<!-- This file is safe to edit. Once it exists it will not be overwritten. -->

# workspace <!-- omit in toc -->

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
        --go            Installs or upgrades go, golangci-lint, hugo and goreleaser
        --psql          Installs or upgrades postgresql
    -b, --bun           Installs or upgrades bun
    -d, --docker        Installs or upgrades docker (rootless)
    -g, --git           Setup default git configuration
    -h, --help          Shows this help message
    -k, --k8s           Installs or upgrades kubectl with k alias, k9s and helm
    -n, --nodejs        Installs or upgrades nodejs, bun and semantic-release
    -s, --shellcheck    Installs or upgrades shellcheck
    -t, --trivy         Installs or upgrades trivy
    -v, --verbose       Enable verbose mode to log every step

Notes:
    All installation are done in $HOME/.local."
```
