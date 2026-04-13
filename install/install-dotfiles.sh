#!/usr/bin/env bash
set -euo pipefail

PROFILE="${ARCH_RICE_PROFILE:-laptop}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$REPO_ROOT/dotfiles"

case "$PROFILE" in
    laptop)
        platform_packages=(
            waybar-laptop
            zsh-pc
        )
        ;;
    pc)
        platform_packages=(
            waybar-pc
            zsh-pc
        )
        ;;
    *)
        echo "Unsupported ARCH_RICE_PROFILE: $PROFILE"
        echo "Supported profiles: laptop, pc"
        exit 1
        ;;
esac

echo "=== Installing Dotfiles (profile: $PROFILE) ==="
cd "$DOTFILES_DIR"

packages=(
    bash
    themes
    hypridle
    hyprland
    hyprlock
    hyprconfig
    hyprpaper
    kitty
    starship
    rofi
    fastfetch
    swaync
    fontconfig
    webapps
    gromitMpx
)

for pkg in "${packages[@]}"; do
    stow -t "$HOME" -v "$pkg"
done

stow -t "$HOME" -v "${platform_packages[0]}"
