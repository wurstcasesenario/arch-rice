#!/usr/bin/env bash

echo "=== Installing Polkit ==="

sudo pacman -S --noconfirm polkit

# sudo systemctl enable --now polkit
