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

In any terminal (SSH or HTTPS depending on your needs):

```sh
git clone --recurse-submodules git@github.com:kilianpaquier/dotfiles.git "$HOME/.dotfiles" && (cd "$HOME/.dotfiles" && ./install.sh)
```

```sh
git clone --recurse-submodules https://github.com/kilianpaquier/dotfiles.git "$HOME/.dotfiles" && (cd "$HOME/.dotfiles" && ./install.sh)
```

### CLI

```
cli.sh -- Easy setup of a codespace or remote debian / ubuntu machine

Options:
    -d, --dir           Set the installation directory (default: /home/debian/.local), does not apply for tools installed with apt
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
    All installation are done by default in /home/debian/.local. It may be overridden by -d or --dir.
```
