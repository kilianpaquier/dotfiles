# chezmoi

A chezmoi repository contains dotfiles (either as symlink or raw files),
scripts and other elements from [**chezmoi**](https://www.chezmoi.io/).

The whole purpose of those repositories is to share computers setup
with automation and shared configurations.

## Specificities

- Use `chezmoi` subfolder for chezmoi elements (per `.chezmoiroot` configuration)
- Update `README.md` prompts table when adding a new init prompt in `.chezmoi.yaml.tmpl`
- Update `.ps1` and `.sh` equivalent scripts when adding a new script element
- Never use `chezmoi` CLI, don't bother with trivial verifications of prompts, scripts, etc.

## Third-party

- `Context7` library ID for chezmoi docs: `/websites/chezmoi_io`.

---

@README.md
