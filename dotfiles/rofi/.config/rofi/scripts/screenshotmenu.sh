#!/usr/bin/env bash

# Rofi Screenshot Menu

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

mkdir -p "$SCREENSHOT_DIR"

options=(
    "󰘔  Window"   # single window
    "󰆟  Region"   # select region
    "󰹑  Screen"   # full screen
)



choice=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Screenshot" -i)

case "$choice" in
    "󰘔  Window")
        hyprshot -m window -o $SCREENSHOT_DIR &
        ;;
    "󰆟  Region")
        hyprshot -m region -o $SCREENSHOT_DIR &
        ;;
    "󰹑  Screen")
        (
        sleep 0.1
        hyprshot -m active -m output -o "$SCREENSHOT_DIR"
        ) &
        ;;
    *)
        exit 0
        ;;
esac
