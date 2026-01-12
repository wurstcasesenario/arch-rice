#!/usr/bin/env bash

echo "=== Installing Network Tools ==="

# Wifi Tools
sudo pacman -S --noconfirm networkmanager iw wpa_supplicant dhclient network-manager-applet
sudo systemctl enable --now NetworkManager

# Bluetooth Tools
sudo pacman -S --noconfirm bluez bluez-utils blueman
sudo systemctl enable --now bluetooth

# === Proton VPN ===
sudo pacman -S --noconfirm wireguard-tools
# nmcli connection import type wireguard file ~/Downloads/Hypo-NO-FREE-5.conf
