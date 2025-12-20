#!/usr/bin/env bash

echo "=== Installing Dotfiles ==="

cd ~/arch-rice/dotfiles

stow -t ~ -v bash

stow -t ~ -v hypridle
stow -t ~ -v hyprland
stow -t ~ -v hyprlock
stow -t ~ -v themeSwitch
stow -t ~ -v waybar
stow -t ~ -v kitty
stow -t ~ -v starship
stow -t ~ -v rofi
stow -t ~ -v fastfetch
stow -t ~ -v vscode
stow -t ~ -v swaync
