# shellcheck shell=sh

# a runtime never selected has no hook marker, so no runtime condition is needed
if command -v rtk >/dev/null 2>&1; then
  ! grep -qs 'rtk hook claude' "$HOME/.claude/settings.json" || rtk init -g --uninstall --auto-patch
  ! grep -qs 'rtk hook codex' "$HOME/.codex/hooks.json" || rtk init -g --uninstall --codex
  [ ! -f "$HOME/.copilot/hooks/rtk-rewrite.json" ] || rtk init -g --uninstall --copilot --auto-patch
fi
