#!/usr/bin/env bash
set -euo pipefail

PROFILE="${ARCH_RICE_PROFILE:-laptop}"

case "$PROFILE" in
    laptop)
        echo "=== Skipping OpenRGB Installation ==="
        ;;
    pc)
        echo "=== Installing OpenRGB ==="
        sudo pacman -S --needed --noconfirm openrgb
        ;;
    *)
        echo "Unsupported ARCH_RICE_PROFILE: $PROFILE"
        echo "Supported profiles: laptop, pc"
        exit 1
        ;;
esac
