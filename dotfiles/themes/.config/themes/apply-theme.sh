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

# Create new Symlink
ln -s "$THEME_DIR" "$CURRENT_LINK"

# swww img "$THEME_DIR/wallpaper.jpg" --transition-fade


hyprctl reload
pkill -SIGUSR2 waybar
pkill rofi

echo "Theme $THEME activated"
