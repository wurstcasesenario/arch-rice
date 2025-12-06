#!/usr/bin/env bash

echo "=== Installing Hyperlanf & WM tools ==="

sudo pacman -S --noconfirm hyprland waybar rofi kitty dunst seatd
sudo systectl enable --now seatd
sudo usermod -aG seat $USER
