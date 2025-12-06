#!/usr/bin/env bash

echo "=== Installing Utilities ==="
sudo pacman -S --noconfirm pipewire-alsa pipewire pipewire-pulse wireplumber pipewire-jack


systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber
 
