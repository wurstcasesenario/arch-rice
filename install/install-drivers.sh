#!/usr/bin/env bash
set -euo pipefail

PROFILE="${ARCH_RICE_PROFILE:-laptop}"

case "$PROFILE" in
    laptop)
        echo "=== Installing Laptop Drivers (Intel Vulkan) ==="
        sudo pacman -S --needed --noconfirm vulkan-intel lib32-vulkan-intel
        ;;
    pc)
        echo "=== Installing PC Drivers (NVIDIA) ==="
        sudo pacman -S --needed --noconfirm \
            nvidia nvidia-utils lib32-nvidia-utils nvidia-settings egl-wayland
        ;;
    *)
        echo "Unsupported ARCH_RICE_PROFILE: $PROFILE"
        echo "Supported profiles: laptop, pc"
        exit 1
        ;;
esac
