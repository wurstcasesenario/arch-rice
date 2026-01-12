#!/usr/bin/env bash

set -euo pipefail

options=(
  "Power Menu"
  "Bluetooth"
  "WiFi"
  "VPN"
  "WebApp"
  "Audio"
  "Themes"
  "Screenshots"
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
    "VPN")
        ~/.config/rofi/scripts/vpnmenu.sh
        ;;
    "WebApp")
        ~/.config/rofi/scripts/webappmenu.sh
        ;;
    "Audio")
        pavucontrol
        ;;
    "Themes")
        ~/.config/rofi/scripts/thememenu.sh
        ;;
    "Screenshots")
        ~/.config/rofi/scripts/screenshotmenu.sh
        ;;

esac
