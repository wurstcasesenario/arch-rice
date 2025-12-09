#!/usr/bin/env bash

echo "=== Installing Audio Utilities ==="

sudo pacman -S --noconfirm pipewire-alsa pipewire pipewire-pulse wireplumber jack2 \
pavucontrol pamixer

systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber
 
