<!-- This file is safe to edit. Once it exists it will not be overwritten. -->

# workspace <!-- omit in toc -->

<p align="center">
  <img alt="GitHub Release" src="https://img.shields.io/github/v/release/kilianpaquier/workspace?include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitHub Issues" src="https://img.shields.io/github/issues-raw/kilianpaquier/workspace?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/kilianpaquier/workspace?style=for-the-badge">
</p>

---

- [Windows](#windows)
- [GNU Linux based](#gnu-linux-based)
  - [CLI](#cli)

## Windows

In a powershell terminal:

```ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kilianpaquier/dotfiles/main/install.ps1" -OutFile "$env:temp\install.ps1"
wt powershell -ExecutionPolicy Bypass -File "$env:temp\install.ps1"
```

## GNU Linux based

In any terminal (windows git bash works too):

```sh
curl -fsSL https://raw.githubusercontent.com/kilianpaquier/dotfiles/main/install.sh -o /tmp/install.sh
chmod +x /tmp/install.sh && /tmp/install.sh
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
    -v, --debug         Enable debug mode to log every step

Notes:
    All installation are done in ${HOME}/.local."
```