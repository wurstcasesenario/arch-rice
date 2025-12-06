#!/usr/bin/env bash

echo "=== Installing Network Tools ==="
sudo pacman -S --noconfirm networkmanager iw wpa_supplicant dhclient
sudo systemctl enable --now NetworkManager
