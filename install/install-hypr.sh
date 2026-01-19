#!/usr/bin/env bash

echo "=== Installing Hyperland & WM tools ==="

sudo pacman -S --noconfirm hyprland waybar \
hypridle hyprlock hyprshot swaync brightnessctl swww \
xdg-desktop-portal-hyprland cliphist hyprpolkitagent

yay -S --noconfirm rose-pine-hyprcursor gromit-mpx hyprshutdown
