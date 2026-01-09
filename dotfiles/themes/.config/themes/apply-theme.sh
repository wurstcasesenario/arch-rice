#!/usr/bin/env bash

THEME="$1"
THEME_DIR="$HOME/.config/themes/$THEME"
CURRENT_LINK="$HOME/.config/themes/current"

if [ -z "$THEME" ]; then
  echo "Theme must be provided"
  exit 1
fi

if [ ! -d "$THEME_DIR" ]; then
  echo "Theme not found"
  exit 1
fi

# Delete old Symlink
if [ -L "$CURRENT_LINK" ] || [ -e "$CURRENT_LINK" ]; then
    rm -rf "$CURRENT_LINK"
fi

ln -s "$THEME_DIR" "$CURRENT_LINK"


WALLPAPER=$(find "$THEME_DIR" -maxdepth 1 -type f \( -iname "wallpaper.*" -o -iname "wallpaper" \) | head -n 1)

if [ -n "$WALLPAPER" ]; then
    swww img "$WALLPAPER"
else
    echo "No wallpaper found in $THEME_DIR"
fi

# === Apply VS Code Theme ===
SETTINGS="$HOME/.config/Code/User/settings.json"
VSTHEME="$(cat "$CURRENT_LINK/vsTheme")"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed"
  exit 1
fi

tmp=$(mktemp)

jq \
  --arg theme "$VSTHEME" \
  '.["workbench.colorTheme"] = $theme' \
  "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"

hyprctl reload
pkill -SIGUSR2 waybar || true
pkill rofi || true
pkill nautilus || true

pkill swaync || true
swaync &

echo "Theme $THEME activated"
