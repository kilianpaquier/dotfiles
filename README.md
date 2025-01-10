<!-- This file is safe to edit. Once it exists it will not be overwritten. -->

# dotfiles <!-- omit in toc -->

<p align="center">
  <img alt="GitHub Issues" src="https://img.shields.io/github/issues-raw/kilianpaquier/dotfiles?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/kilianpaquier/dotfiles?style=for-the-badge">
</p>

---

- [Windows](#windows)
- [Debian](#debian)

## Windows

In a powershell terminal:

```ps1
(New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/kilianpaquier/dotfiles/main/install.ps1") | wt powershell -command -
```

## Debian

In any terminal (SSH or HTTPS depending on your needs):

```sh
git clone --recurse-submodules git@github.com:kilianpaquier/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/install.sh"
```

```sh
git clone --recurse-submodules https://github.com/kilianpaquier/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/install.sh"
```
