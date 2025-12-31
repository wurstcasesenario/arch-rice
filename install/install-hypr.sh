#!/usr/bin/env bash

echo "=== Installing Hyperland & WM tools ==="

sudo pacman -S --noconfirm hyprland waybar \
hypridle hyprlock hyprshot swaync brightnessctl swww

yay -S --noconfirm rose-pine-hyprcursor
