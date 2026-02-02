#!/usr/bin/env bash

echo "=== Installing Sober (Roblox) ==="

if ! flatpak info org.vinegarhq.Sober &>/dev/null; then
    flatpak install -y flathub org.vinegarhq.Sober
else
    echo "Sober is already installed."
fi
