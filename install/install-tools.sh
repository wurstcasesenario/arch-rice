#!/usr/bin/env bash

set -euo pipefail

echo "=== Installing Utilities ==="

if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "[multilib]" | sudo tee -a /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
else
    sudo sed -i 's/^#\[multilib\]/[multilib]/' /etc/pacman.conf
    sudo sed -i 's/^#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf
fi

sudo pacman -Sy --noconfirm

sudo pacman -S --noconfirm nano git base-devel sudo base

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
