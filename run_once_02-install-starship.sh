#!/bin/bash

# External installer for Starship prompt.
# Keep package-manager sync in run_once_01; use this only for tools that intentionally
# follow the upstream installer instead of package-mapping.toml.
set -e

log() {
    printf '==> %s\n' "$1"
}

install_starship() {
    if command -v starship &> /dev/null; then
        log "Starship is already installed: $(starship --version)"
        return
    fi

    log "Installing Starship with the official installer"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"

    if ! command -v starship &> /dev/null; then
        printf '%s\n' "Error: Starship installation failed" >&2
        exit 1
    fi

    log "Starship installation completed successfully"
}

install_starship
