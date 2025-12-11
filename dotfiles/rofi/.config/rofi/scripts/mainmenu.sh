#!/usr/bin/env bash

options=(
  "Power Menu"
  "Bluetooth"
  "WiFi"
)

# Rofi anzeigen
choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Main Menu")

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
esac
