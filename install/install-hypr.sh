#!/usr/bin/env bash

echo "=== Installing Hyperland & WM tools ==="

sudo pacman -S --noconfirm hyprland waybar \
hypridle hyprlock hyprshot swaync brightnessctl \
xdg-desktop-portal-hyprland cliphist hyprpolkitagent \
hyprpaper

yay -S --noconfirm rose-pine-hyprcursor gromit-mpx hyprshutdown
