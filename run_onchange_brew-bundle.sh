#!/bin/sh
set -e

# Run brew bundle when Brewfile changes
BREWFILE="$HOME/.config/packages/brewfile"

if [ -x "$(command -v brew)" ] && [ -f "$BREWFILE" ]; then
  brew bundle --file="$BREWFILE"
fi
