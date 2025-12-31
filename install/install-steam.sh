#!/usr/bin/env bash
set -e

echo "=== Installing Steam & Gamescope & Proton GE ==="

sudo pacman -Syu --noconfirm  vulkan-intel lib32-vulkan-intel

sudo pacman -Syu --noconfirm steam

# sudo pacman -Syu --noconfirm gamescope

mkdir -p ~/.steam/root/compatibilitytools.d

LATEST=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
    | grep browser_download_url \
    | grep tar.gz \
    | cut -d '"' -f 4)

TMP_FILE=$(mktemp --suffix=.tar.gz)

trap rm -f "$TMP_FILE"' EXIT

curl -L "$LATEST" -o "$TMP_FILE"

tar -xf "$TMP_FILE" -C ~/.steam/steam/compatibilitytools.d
