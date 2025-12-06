#!/usr/bin/env bash

echo "=== Installing Dotfiles ==="

cd ~/arch-rice/dotfiles

stow -v bash

stow -v hyprland
stow -v  waybar
stow -v kitty
stow -v dunst
stow -v rofi
