#!/bin/bash

# Setup Neovim
set -e

echo "Setting up Neovim..."

# Create backup directory for vim
mkdir -p ~/.vimbackup

# Install Neovim if not installed
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    if command -v brew &> /dev/null; then
        brew install neovim
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y neovim
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y neovim
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm neovim
    else
        echo "Please install Neovim manually"
        exit 1
    fi
fi

# Install dependencies for Neovim
echo "Installing Neovim dependencies..."

# Python support
if command -v pip3 &> /dev/null; then
    pip3 install --user pynvim
fi

# Node support  
if command -v npm &> /dev/null; then
    npm install -g neovim
fi

# Ruby support
if command -v gem &> /dev/null; then
    gem install neovim
    gem install rubocop
fi

# Install language servers and tools
echo "Installing language servers and development tools..."

# Install ripgrep and fd for Telescope
if command -v brew &> /dev/null; then
    brew install ripgrep fd
elif command -v apt &> /dev/null; then
    sudo apt install -y ripgrep fd-find
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm ripgrep fd
fi

# Install formatters and linters
if command -v pip3 &> /dev/null; then
    pip3 install --user black flake8 pylint
fi

if command -v npm &> /dev/null; then
    npm install -g prettier eslint typescript typescript-language-server
fi

if command -v go &> /dev/null; then
    go install golang.org/x/tools/gopls@latest
    go install golang.org/x/tools/cmd/goimports@latest
fi

if command -v cargo &> /dev/null; then
    cargo install rustfmt
fi

echo "Neovim setup completed!"
echo "Run 'nvim' and lazy.nvim will automatically install plugins on first launch."
