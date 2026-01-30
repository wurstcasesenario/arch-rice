#!/usr/bin/env bash

echo "=== Installing Polkit ==="

sudo pacman -S --needed --noconfirm polkit

# sudo systemctl enable --now polkit
