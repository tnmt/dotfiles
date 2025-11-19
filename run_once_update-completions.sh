#!/bin/bash

set -euo pipefail

COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
mkdir -p "$COMPLETIONS_DIR"

declare -A completion_commands=(
  [mise]="mise completion zsh"
  [chezmoi]="chezmoi completion zsh"
)

for tool in "${!completion_commands[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    out_file="$COMPLETIONS_DIR/_$tool"
    echo "Updating completion for $tool -> $out_file"
    ${completion_commands[$tool]} >"$out_file"
  else
    echo "Skipping $tool: not installed"
  fi
done
