#!/usr/bin/env bash

echo "=== Installing Fonts ==="

sudo pacman -S --noconfirm noto-fonts noto-fonts-emoji ttf-dejavu ttf-liberation

# Nerd Fonts (Terminal, Starship, Waybar)
# yay -S --noconfirm ttf-jetbrains-mono-nerd
yay -S --noconfirm ttf-cascadia-mono-nerd


# Awesome font for Waybar Ions
sudo pacman -S --noconfirm otf-font-awesome
