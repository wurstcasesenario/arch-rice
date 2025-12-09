#!/bin/bash

WALL_DIR="$HOME/themeSwitch/Wallpapers"

CMD="$(pwd)"
cd "$WALL_DIR" || exit

IFS=$'\n'

FILES=($(ls *.jpg *.png 2>/dev/null))

if [ ${#FILES[@]} -eq 0 ]; then
    notify-send "Keine Wallpaper gefunden" "Im Ordner gibt es keine .jpg oder .png Dateien."
    exit 1
fi

SELECTED_WALL=$(for a in "${FILES[@]}"; do
    echo -en "$a\0icon\x1f$WALL_DIR/$a\n"
done | rofi -dmenu -p "")

if [ -n "$SELECTED_WALL" ]; then
    wallset-backend "$SELECTED_WALL"
fi

cd "$CMD" || exit
