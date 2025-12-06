#!/usr/bin/env bash

echo "=== Installing Dotfiles ==="

cd ~/arch-rice/dotfiles

stow -v bash

stow -t ~ -v hypr
stow -t ~ -v  waybar
stow -t ~ -v kitty
#stow -t ~ -v wofi
