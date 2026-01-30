#!/usr/bin/env bash

echo "=== Installing Browsers ==="

sudo pacman -S --needed --noconfirm firefox chromium

xdg-settings set default-web-browser firefox.desktop

