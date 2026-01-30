#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing Utilities ==="

PACMAN_CONF="/etc/pacman.conf"

# ---- Enable multilib safely (no appending, no testing repos touched) ----
if grep -Eq '^\s*#\s*\[multilib\]' "$PACMAN_CONF"; then
    echo "Enabling multilib repository..."
    sudo sed -i \
        -e 's/^\s*#\s*\[multilib\]/[multilib]/' \
        -e '/^\[multilib\]/,/^\[/{s/^\s*#\s*Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/}' \
        "$PACMAN_CONF"
else
    echo "Multilib already enabled. Skipping."
fi

sudo pacman -Syy --noconfirm

# ---- Base packages ----
sudo pacman -S --needed --noconfirm \
    nano git base-devel base sudo

# ---- AUR setup ----
AUR_DIR="$HOME/builds/aurpacman"
mkdir -p "$AUR_DIR"

if [ ! -d "$AUR_DIR/yay/.git" ]; then
    echo "Cloning yay AUR repo..."
    git clone https://aur.archlinux.org/yay.git "$AUR_DIR/yay"
else
    echo "Updating yay..."
    git -C "$AUR_DIR/yay" pull
fi

if pacman -Qi yay &>/dev/null; then
    echo "yay already installed. Skipping build."
else
    cd "$AUR_DIR/yay"
    makepkg -si --noconfirm
fi


# ---- Flatpak ----
sudo pacman -S --needed --noconfirm flatpak
