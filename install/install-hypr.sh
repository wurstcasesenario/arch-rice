#!/usr/bin/env bash

echo "=== Installing Hyperland & WM tools ==="

sudo pacman -S --needed --noconfirm hyprland waybar \
hypridle hyprlock hyprshot swaync brightnessctl \
xdg-desktop-portal-hyprland cliphist hyprpolkitagent \
hyprpaper hyprsunset

yay -S --needed --noconfirm rose-pine-hyprcursor

sudo pacman -S --needed --noconfirm power-profiles-daemon