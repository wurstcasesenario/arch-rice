#!/usr/bin/env bash

echo "=== Installing Terminal Tools ==="

sudo pacman -S --needed --noconfirm kitty starship fastfetch tree htop zsh man


# === Installing zsh Plugins ===
# Path to custom Zsh plugins
ZSH_CUSTOM="$HOME/.zsh_custom"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

# Ensure plugins directory exists
mkdir -p "$PLUGINS_DIR"

echo "=== Installing Zsh plugins ==="

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
else
    echo "Updating zsh-autosuggestions..."
    git -C "$PLUGINS_DIR/zsh-autosuggestions" pull
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
else
    echo "Updating zsh-syntax-highlighting..."
    git -C "$PLUGINS_DIR/zsh-syntax-highlighting" pull
fi

