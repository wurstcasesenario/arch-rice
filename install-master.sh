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
./install-qt.sh
./install-fileManager.sh
./install-audio.sh
./install-polkit.sh
./install-terminal.sh
./install-applications.sh
./install-discord.sh
./install-vscode.sh
./install-steam.sh
./install-browser.sh
./install-rofi.sh

./install-dotfiles.sh

./install-systemd.sh
