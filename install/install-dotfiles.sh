#!/usr/bin/env bash
set -euo pipefail

PROFILE="${ARCH_RICE_PROFILE:-laptop}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$REPO_ROOT/dotfiles"

case "$PROFILE" in
    laptop)
        platform_packages=(
            waybar-laptop
            zsh-laptop
        )
        opposite_platform_packages=(
            waybar-pc
            zsh-pc
        )
        ;;
    pc)
        platform_packages=(
            waybar-pc
            zsh-pc
        )
        opposite_platform_packages=(
            waybar-laptop
            zsh-laptop
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
    hyprpaper
    kitty
    starship
    rofi
    fastfetch
    swaync
    scripts
    fontconfig
    webapps
    gromitMpx
)

for pkg in "${packages[@]}"; do
    stow -t "$HOME" -v "$pkg"
done

for pkg in "${opposite_platform_packages[@]}"; do
    if [[ -d "$pkg" ]]; then
        stow -D -t "$HOME" -v "$pkg" || true
    fi
done

for pkg in "${platform_packages[@]}"; do
    stow -t "$HOME" -v "$pkg"
done
