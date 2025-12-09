#!/usr/bin/env bash
set -e
echo "=== Installing Steam & Gamescope & Proton GE ==="

sudo pacman -S --noconfirm steam

sudo pacman -S --noconfirm gamescope

mkdir -p ~/.steam/root/compatibilitytools.d

LATEST=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
    | grep browser_download_url \
    | grep tar.gz \
    | cut -d '"' -f 4)

curl -L "$LATEST" -o proton-ge.tar.gz

tar -xf proton-ge.tar.gz -C ~/.steam/steam/compatibilitytools.d

rm proton-ge.tar.gz

