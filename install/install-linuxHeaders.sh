#!/usr/bin/env bash

echo "=== Installing Linux Headers ==="
sudo pacman -S --needed --noconfirm linux linux-headers
