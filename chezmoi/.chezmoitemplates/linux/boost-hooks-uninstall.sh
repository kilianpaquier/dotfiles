# shellcheck shell=sh

# a runtime never selected has no hook marker, so no runtime condition is needed
if command -v boost >/dev/null 2>&1; then
  ! grep -qs boost-hook-claude "$HOME/.claude/settings.json" || boost init --accept-terms --uninstall --claude
  ! grep -qs boost-hook-codex "$HOME/.codex/hooks.json" || boost init --accept-terms --uninstall --codex
  [ ! -f "$HOME/.copilot/hooks/boost.json" ] || boost init --accept-terms --uninstall --copilot
fi
