#!/usr/bin/env bash

echo "=== Installing Fonts ==="

sudo pacman -S --noconfirm noto-fonts noto-fonts-emoji

# Nerdfont for Icons in Starship
yay -S --noconfirm nerd-fonts-caskaydia-cove 


# Awesome font for Waybar Ions
sudo pacman -S --noconfirm otf-font-awesome
