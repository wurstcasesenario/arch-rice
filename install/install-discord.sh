#!/usr/bin/env bash

echo "=== Installing Discord & Vencord ==="

packages=("discord" "vencord-bin")

for pkg in "${packages[@]}"; do
    if yay -Qi "$pkg" &>/dev/null; then
        echo "[OK] $pkg is already installed."
    else
        echo "[INSTALL] $pkg is not installed. Installing..."
        yay -S --noconfirm "$pkg"
    fi
done

