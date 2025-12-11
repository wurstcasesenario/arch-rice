#!/usr/bin/env bash

# Rofi Powermenu

options=(
    "  Shutdown"
    "  Reboot"
    "  Lock"
    "  Suspend"
    "󰗼  Logout"
    "󰐥  Cancel"
)

choice=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Power" -i)

case "$choice" in
    "  Shutdown")
        systemctl poweroff
        ;;
    "  Reboot")
        systemctl reboot
        ;;
    "  Lock")
        hyprlock
        ;;
    "  Suspend")
        systemctl suspend
        ;;
    "󰗼  Logout")
        loginctl terminate-session "$XDG_SESSION_ID"
        ;;
    *)
        exit 0
        ;;
esac
