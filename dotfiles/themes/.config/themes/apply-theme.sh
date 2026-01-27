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

echo "ln -s "$THEME_DIR" "$CURRENT_LINK""


# WALLPAPER=$(find "$THEME_DIR" -maxdepth 1 -type f \( -iname "wallpaper.*" -o -iname "wallpaper" \) | head -n 1)

# if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
#     # Get list of connected monitors
#     MONITORS=$(hyprctl monitors | grep '^Monitor ' | awk '{print $2}')
    
#     # Set wallpaper for each monitor
#     for MON in $MONITORS; do
#         hyprctl hyprpaper wallpaper "$MON","$WALLPAPER"
#     done
    
#     echo "Wallpaper set: $WALLPAPER"
# else
#     echo "No wallpaper found in $THEME_DIR"
# fi

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

# === Apply GTK Theme ===
GTK_THEME="$(cat "$CURRENT_LINK/gtkTheme")"
GTK_THEME_FOLDER="$HOME/.themes"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

mkdir -p "$GTK_THEME_FOLDER"
GTK_CURRENT_LINK="$GTK_THEME_FOLDER/current"
if [ -L "$GTK_CURRENT_LINK" ] || [ -e "$GTK_CURRENT_LINK" ]; then
  rm -rf "$GTK_CURRENT_LINK"
fi
ln -s "$GTK_THEME_FOLDER/$GTK_THEME" "$GTK_CURRENT_LINK"

rm -rf "$HOME/.config/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/assets"

ln -s "$GTK_THEME_FOLDER/$GTK_THEME/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
ln -s "$GTK_THEME_FOLDER/$GTK_THEME/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
ln -s "$GTK_THEME_FOLDER/$GTK_THEME/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"


hyprctl reload
pkill hyprpaper
hyprpaper &

pkill -SIGUSR2 waybar || true
pkill rofi || true
pkill nautilus || true

swaync-client --reload-config


echo "Theme $THEME activated"
