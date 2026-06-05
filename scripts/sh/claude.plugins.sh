#!/bin/sh

set -e

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude is not installed, please do it before installing initial plugins"
  exit 2
fi
installed_marketplaces=$(claude plugin marketplace list)
installed_plugins=$(claude plugin list)

if ! echo "$installed_marketplaces" | grep -q https://gitlab.com/kilianpaquier/ai-marketplace.git; then
  claude plugin marketplace add https://gitlab.com/kilianpaquier/ai-marketplace.git
fi
claude plugin marketplace update

for plugin in codegraph opentofu schema-converter; do
  if echo "$installed_plugins" | grep -q $plugin@bunch-of; then
    claude plugin update $plugin@bunch-of
  else
    claude plugin install $plugin@bunch-of
  fi
done

for plugin in \
  atomic-agents \
  claude-code-setup \
  claude-md-management \
  code-review \
  commit-commands \
  context7 \
  feature-dev \
  github \
  gitlab \
  gopls-lsp \
  pr-review-toolkit \
  remember \
  security-guidance \
  skill-creator; do
  if echo "$installed_plugins" | grep -q $plugin@claude-plugins-official; then
    claude plugin update $plugin@claude-plugins-official
  else
    claude plugin install $plugin@claude-plugins-official
  fi
done
