#!/bin/bash

echo "=== Updating System ==="
sudo pacman -Syu --noconfirm


./install/install-stow.sh
./install/install-network.sh
./install/install-hypr.sh
./install/install-fonts.sh
./install/install-tools.sh
./install/install-audio.sh
./install/install-polkit.sh
./install/install-applications.sh

./install/install-dotfiles.sh
