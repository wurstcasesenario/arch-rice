#!/usr/bin/env bash
set -euo pipefail

rofi_menu() {
    local prompt="$1"
    shift
    printf '%s\n' "$@" | rofi -dmenu -p "$prompt"
}

main_menu() {
    rofi_menu "Main Menu" \
        "󰍜  System" \
        "󰖩  Network" \
        "󰛖  Appearance" \
        "󰏖  Apps"
}

system_menu() {
    rofi_menu "System" \
        "  Power Menu" \
        "󰂄  Battery Saver" \
        "←  Back"
}

network_menu() {
    rofi_menu "Network" \
        "󰖩  WiFi" \
        "󰂯  Bluetooth" \
        "󰒘  VPN" \
        "←  Back"
}

appearance_menu() {
    rofi_menu "Appearance" \
        "󰖔  Night Mode" \
        "󰉼  Themes" \
        "←  Back"
}

apps_menu() {
    rofi_menu "Apps" \
        "󰖟  WebApp" \
        "󰕾  Audio" \
        "󰄀  Screenshots" \
        "←  Back"
}

# --- main loop ---
current="main"

while true; do
    case "$current" in
        main)
            choice=$(main_menu)
            case "$choice" in
                *"System") current="system" ;;
                *"Network") current="network" ;;
                *"Appearance") current="appearance" ;;
                *"Apps") current="apps" ;;
                *) exit 0 ;;
            esac
            ;;
        system)
            choice=$(system_menu)
            case "$choice" in
                *"Power Menu") ~/.config/rofi/scripts/powermenu.sh ;;
                *"Battery Saver") ~/.config/rofi/scripts/batterysavemenu.sh ;;
                *"Back") current="main" ;;
                *) exit 0 ;;
            esac
            ;;
        network)
            choice=$(network_menu)
            case "$choice" in
                *"WiFi") ~/.config/rofi/scripts/wifimenu.sh ;;
                *"Bluetooth") ~/.config/rofi/scripts/bluetoothmenu.sh ;;
                *"VPN") ~/.config/rofi/scripts/vpnmenu.sh ;;
                *"Back") current="main" ;;
                *) exit 0 ;;
            esac
            ;;
        appearance)
            choice=$(appearance_menu)
            case "$choice" in
                *"Night Mode") ~/.config/rofi/scripts/nightmodemenu.sh ;;
                *"Themes") ~/.config/rofi/scripts/thememenu.sh ;;
                *"Back") current="main" ;;
                *) exit 0 ;;
            esac
            ;;
        apps)
            choice=$(apps_menu)
            case "$choice" in
                *"WebApp") ~/.config/rofi/scripts/webappmenu.sh ;;
                *"Audio") pavucontrol ;;
                *"Screenshots") ~/.config/rofi/scripts/screenshotmenu.sh ;;
                *"Back") current="main" ;;
                *) exit 0 ;;
            esac
            ;;
    esac
done