#!/usr/bin/env bash

set -euo pipefail

echo "=== Installing Utilities ==="

sudo pacman -S --noconfirm nano git base-devel sudo

# Define AUR build directory
AUR_DIR="$HOME/builds/aur"
mkdir -p "$AUR_DIR"

# Install yay
if [ ! -d "$AUR_DIR/yay" ]; then
    echo "Cloning yay AUR repo..."
    git clone https://aur.archlinux.org/yay.git "$AUR_DIR/yay"
else
    echo "yay repo already exists, pulling changes..."
    git -C "$AUR_DIR/yay" pull
fi

cd "$AUR_DIR/yay"

makepkg -si --noconfirm
