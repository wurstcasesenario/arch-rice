#!/usr/bin/env bash
set -e

echo "=== Installing Steam & Gamescope & Proton GE ==="

sudo pacman -S --needed --noconfirm steam

# sudo pacman -S --needed --noconfirm gamescope

# ---- Proton GE ----
STEAM_COMPAT="$HOME/.steam/root/compatibilitytools.d"
mkdir -p "$STEAM_COMPAT"

# Get latest Proton GE release URL
LATEST_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest \
    | grep browser_download_url \
    | grep tar.gz \
    | cut -d '"' -f 4)

LATEST_NAME=$(basename "$LATEST_URL" .tar.gz)

# Check if already installed
if [ -d "$STEAM_COMPAT/$LATEST_NAME" ]; then
    echo "Proton GE ($LATEST_NAME) already installed. Skipping."
    exit 0
fi

echo "Downloading Proton GE: $LATEST_NAME"

TMP_FILE=$(mktemp --suffix=.tar.gz)
trap 'rm -f "$TMP_FILE"' EXIT

curl -L "$LATEST_URL" -o "$TMP_FILE"
tar -xf "$TMP_FILE" -C "$STEAM_COMPAT"

echo "Proton GE installed successfully."