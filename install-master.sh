#!/bin/bash

echo "=== Updating System ==="
sudo pacman -Syu --noconfirm

INSTALL_PATH="$HOME/arch-rice/install"

cd "$INSTALL_PATH" || exit 1

./install-stow.sh
./install-tools.sh
./install-fonts.sh
./install-network.sh
./install-hypr.sh
./install-nautilus.sh
./install-audio.sh
./install-polkit.sh
./install-applications.sh

./install-dotfiles.sh
