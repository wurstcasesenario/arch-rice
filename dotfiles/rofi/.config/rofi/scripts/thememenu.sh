#!/usr/bin/env bash

THEMES_DIR="$HOME/.config/themes"
APPLY_SCRIPT="$THEMES_DIR/apply-theme.sh"

# Get Themes
entries=()

for theme in "$THEMES_DIR"/*; do
    [ -d "$theme" ] || continue

    name="$(basename "$theme")"

    # skip special dirs
    [ "$name" = "current" ] && continue

    # find wallpaper
    wallpaper="$(find "$theme" -maxdepth 1 -type f \( \
        -iname "wallpaper.*" -o \
        -iname "wallpaper" \
    \) | head -n 1)"

    if [ -n "$wallpaper" ]; then
        entries+=("$name\x00icon\x1f$wallpaper")
    else
        entries+=("$name")
    fi
done

# Starte rofi
selected="$(printf '%b\n' "${entries[@]}" | rofi \
    -dmenu \
    -i \
    -p "Theme" \
    -show-icons \
    -icon-theme "Papirus" \
)"

[ -z "$selected" ] && exit 0

# Theme anwenden
"$APPLY_SCRIPT" "$selected"
