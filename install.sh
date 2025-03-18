#!/bin/bash
set -e

# Set XDG_CONFIG_HOME to ~/.config if not already defined
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Create the Neovim config directory if it doesn’t exist
mkdir -p "$XDG_CONFIG_HOME/"

# Remove any existing nvim directory or symlink
rm -rf "$XDG_CONFIG_HOME/nvim"

# Symlink the entire dotfiles repo to ~/.config/nvim
ln -sf "$PWD" "$XDG_CONFIG_HOME/nvim"

echo "Neovim dotfiles installed to $XDG_CONFIG_HOME/nvim."
