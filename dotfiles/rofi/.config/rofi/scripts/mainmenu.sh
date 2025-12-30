#!/usr/bin/env bash

set -euo pipefail

options=(
  "Power Menu"
  "Bluetooth"
  "WiFi"
  "Wallpaper"
  "WebApp"
  "Themes"
)

# Show Rofi
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Main Menu")

[ -z "$choice" ] && exit 0

case "$choice" in
    "Power Menu")
        ~/.config/rofi/scripts/powermenu.sh
        ;;
    "Bluetooth")
        ~/.config/rofi/scripts/bluetoothmenu.sh
        ;;
    "WiFi")
        ~/.config/rofi/scripts/wifimenu.sh
        ;;
    "Wallpaper")
        ~/.config/rofi/scripts/wallpapermenu.sh
        ;;
    "WebApp")
        ~/.config/rofi/scripts/webappmenu.sh
        ;;
    "Themes")
        ~/.config/rofi/scripts/thememenu.sh
        ;;

esac
