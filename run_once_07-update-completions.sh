#!/bin/bash

set -eo pipefail

COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
mkdir -p "$COMPLETIONS_DIR"

update_completion() {
  local tool="$1"
  shift
  if command -v "$tool" >/dev/null 2>&1; then
    out_file="$COMPLETIONS_DIR/_$tool"
    echo "Updating completion for $tool -> $out_file"
    "$@" >"$out_file"
  else
    echo "Skipping $tool: not installed"
  fi
}

update_completion mise mise completion zsh
update_completion chezmoi chezmoi completion zsh
