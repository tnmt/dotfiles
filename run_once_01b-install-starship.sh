#!/bin/bash

# Install Starship prompt
set -e

if command -v starship &> /dev/null; then
    echo "Starship is already installed. Version: $(starship --version)"
    exit 0
fi

echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"

if command -v starship &> /dev/null; then
    echo "Starship installation completed successfully!"
else
    echo "Error: Starship installation failed"
    exit 1
fi
